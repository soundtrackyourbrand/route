defmodule Route.Mixfile do
  use Mix.Project

  @version "1.0.0"

  def project do
    [
      app: :route,
      version: @version,
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      package: package(),
      description: "Route macro for routing to multiple routers in phoenix endpoint (or plug router)"
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:plug, "~> 1.4"}
    ]
  end

  defp package do
    %{
      licence: ["MIT"],
      maintainers: ["Fredrik Enestad"],
      links: %{"GitHub" => "https://github.com/soundtrackyourbrand/route"}
    }
  end
end
