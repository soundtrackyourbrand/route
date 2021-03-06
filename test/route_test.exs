defmodule RouteTest do
  use ExUnit.Case
  use Plug.Test

  doctest Route

  defmodule API do
    use Plug.Router

    plug(:match)
    plug(:dispatch)

    get "/" do
      resp(conn, 200, "api")
    end
  end

  defmodule Host do
    use Plug.Router

    plug(:match)
    plug(:dispatch)

    get "/" do
      resp(conn, 200, "host")
    end
  end

  defmodule Path do
    use Plug.Router

    plug(:match)
    plug(:dispatch)

    get "/sub" do
      resp(conn, 200, "subpath")
    end

    get "/" do
      resp(conn, 200, "path")
    end
  end

  defmodule HostPath do
    use Plug.Router

    plug(:match)
    plug(:dispatch)

    get "/" do
      resp(conn, 200, "host+path")
    end
  end

  defmodule Forward do
    use Plug.Router

    plug(:match)
    plug(:dispatch)

    forward("/to_path", to: RouteTest.Path)
  end

  defmodule Router do
    use Plug.Router
    use Route

    plug(:match)
    plug(:dispatch)

    route(host: "api.", to: RouteTest.API)
    route(host: "host.", path: "path", to: RouteTest.HostPath)
    route(host: "host.example.com", to: RouteTest.Host)
    route(path: "/path", to: RouteTest.Path)
    route(path: "/forward", to: RouteTest.Forward)

    match _ do
      conn
    end
  end

  test "routes to router based on subdomain" do
    assert call(RouteTest.Router, conn(:get, "http://api.example.com/")).resp_body == "api"
  end

  test "routes to router based on full hostname" do
    assert call(RouteTest.Router, conn(:get, "http://host.example.com/")).resp_body == "host"
  end

  test "routes based on path" do
    assert call(RouteTest.Router, conn(:get, "http://example.com/path/sub")).resp_body ==
             "subpath"

    assert call(RouteTest.Router, conn(:get, "http://example.com/path")).resp_body == "path"
    assert call(RouteTest.Router, conn(:get, "http://example.com/path/")).resp_body == "path"
  end

  test "routes based on both path and host" do
    assert call(RouteTest.Router, conn(:get, "http://host.example.com/path")).resp_body ==
             "host+path"
  end

  test "sets the private plug_route" do
    %Plug.Conn{private: %{plug_route: {match_path, _}}} =
      call(RouteTest.Router, conn(:get, "http://example.com/path/sub"))

    assert match_path == "/path/*glob/sub"

    %Plug.Conn{private: %{plug_route: {match_path, _}}} =
      call(RouteTest.Router, conn(:get, "http://example.com/forward/to_path/sub"))

    assert match_path == "/forward/*glob/to_path/*glob/sub"
  end

  defp call(mod, conn) do
    mod.call(conn, [])
  end
end
