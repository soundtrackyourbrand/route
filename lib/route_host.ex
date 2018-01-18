defmodule RouteHost do
  @doc false
  defmacro __using__(_opts) do
    quote do
      @behaviour Plug
      def init(opts), do: opts

      def call(conn, opts) do
        route_host_plug(super(conn, opts), [])
      end

      import RouteHost, only: [route_host: 2]

      Module.register_attribute(__MODULE__, :hosts, accumulate: true)
      @before_compile RouteHost
    end
  end

  @doc false
  defmacro __before_compile__(env) do
    Module.get_attribute(env.module, :hosts)
    |> Enum.reverse
    |> Enum.map(fn {host, route} ->
      host_match = Plug.Router.Utils.build_host_match(host)
      quote do
        def route_host_plug(%Plug.Conn{host: unquote(host_match)} = conn, opts) do
          apply(unquote(route), :call, [conn, opts])
        end
      end
    end)
  end

  defmacro route_host(host, router) do
    quote do
      @hosts {unquote(host), unquote(router)}
    end
  end
end
