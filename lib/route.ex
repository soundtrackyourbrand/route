defmodule Route do
  @moduledoc """
  Route macro for routing to multiple routers in phoenix endpoint (or a plug router)
  """

  @doc false
  defmacro __using__(_opts) do
    quote do
      @behaviour Plug
      def init(opts), do: opts

      def call(conn, opts) do
        route_plug(super(conn, opts), [])
      end

      import Route, only: [route: 1]

      Module.register_attribute(__MODULE__, :routes, accumulate: true)
      @before_compile Route
    end
  end

  @doc false
  defmacro __before_compile__(env) do
    Module.get_attribute(env.module, :routes)
    |> Enum.reverse()
    |> Enum.map(fn {path, host, router} ->
      host_match = Plug.Router.Utils.build_host_match(host)
      {_, path_match} = Plug.Router.Utils.build_path_match(path <> "/*glob")

      quote do
        def route_plug(
              %Plug.Conn{host: unquote(host_match), path_info: unquote(path_match)} = conn,
              opts
            ) do
          Plug.Router.Utils.forward(conn, var!(glob), unquote(router), opts)
        end
      end
    end)
  end

  @doc """
  Route requests to a router, accepts several `opts` described below

  ## Examples
      route host: "api.", to: MyAPIRouter
      route path: "/admin", to: MyAdminRouter
      route to: MyDefaultRouter
  ## Options
  `route/1` accept the following `opts`:
    * `:host` - the host which the route should match. Defaults to `nil`
    * `:path` - the path which the route should match. Defaults to `""`
    * `:to` - a Plug that will be called in case the route matches. Required
  """
  defmacro route(opts) do
    router = Keyword.fetch!(opts, :to)
    path = Keyword.get(opts, :path, "")
    host = Keyword.get(opts, :host, nil)

    quote do
      @routes {unquote(path), unquote(host), unquote(router)}
    end
  end
end
