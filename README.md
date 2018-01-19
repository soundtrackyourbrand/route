# Route

Elixir macro for routing to multiple routers from phoenix endpoint (or a plug router)

## Example

```elixir
defmodule Endpoint do
  use Phoenix.Endpoint, otp_app: :my_app
  use Route

  route path: "/admin", to: Admin.Router
  route host: "api.", to: API.Router
  route to: Web.Router
end

defmodule API.Router do
  use MyApp.Web, :router

  get "/" do
    resp(conn, 200, "hello api")
  end
end

defmodule Web.Router do
  use MyApp.Web, :router

  get "/" do
    resp(conn, 200, "hello web")
  end
end

defmodule Web.Admin do
  use MyApp.Web, :router

  get "/" do
    resp(conn, 200, "hello admin")
  end
end

```
