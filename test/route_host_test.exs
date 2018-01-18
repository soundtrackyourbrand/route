defmodule RouteHostTest do
  use ExUnit.Case
  use Plug.Test

  doctest RouteHost

  defmodule API do
    use Plug.Router

    plug :match
    plug :dispatch

    get "/" do
      resp(conn, 200, "api")
    end	
  end

  defmodule Host do
    use Plug.Router

    plug :match
    plug :dispatch

    get "/" do
      resp(conn, 200, "host")
    end	
  end

  defmodule Default do
    use Plug.Router

    plug :match
    plug :dispatch

    get "/" do
      resp(conn, 200, "default")
    end	
  end

  defmodule Router do
    use Plug.Router
    use RouteHost

    plug :match
    plug :dispatch

    route_host "api.", RouteHostTest.API
    route_host "host.example.com", RouteHostTest.Host
    route_host nil, RouteHostTest.Default

    match _ do
      conn
    end
  end

  test "routes to router based on subdomain" do
    assert call(RouteHostTest.Router, conn(:get, "http://api.example.com/")).resp_body == "api"
  end
  test "routes to router based on hostname" do
    assert call(RouteHostTest.Router, conn(:get, "http://host.example.com/")).resp_body == "host"
  end
  test "routes unspecified routes to nil" do
    assert call(RouteHostTest.Router, conn(:get, "http://www.example.com/")).resp_body == "default"
  end

  defp call(mod, conn) do
    mod.call(conn, [])
  end
end
