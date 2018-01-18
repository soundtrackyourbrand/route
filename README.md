# RouteHost

Route requests based on host for plug and phoenix

## Usage

In your base router (or Endpoint in phoenix), use `RouteHost` and then route requests based on host to other routers. 

It uses the [host matcher](https://github.com/elixir-plug/plug/blob/master/lib/plug/router/utils.ex#L25-L43) from [elixir-plug](https://github.com/elixir-plug/plug)

## Example

```elixir
defmodule Router do
  use Plug.Router
  use RouteHost

  plug :match
  plug :dispatch

  route_host "api.", APIRouter
  route_host nil, DefaultRouter

  match _ do
    conn
  end
end

defmodule APIRouter do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/" do
    resp(conn, 200, "hello api")
  end	
end

defmodule DefaultRouter do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/" do
    resp(conn, 200, "hello default")
  end	
end

```
