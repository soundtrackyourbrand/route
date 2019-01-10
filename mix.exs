defmodule Route.Mixfile do
  use Mix.Project

  @version "1.0.0"
  @url "https://github.com/soundtrackyourbrand/route"

  def project do
    [
      app: :route,
      version: @version,
      elixir: "~> 1.5",
      start_permanent: Mix.env() == :prod,
      build_embedded: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description:
        "Route macro for routing to multiple routers in phoenix endpoint (or a plug router)",
      docs: [
        source_ref: "v#{@version}",
        source_url: @url
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:plug, "~> 1.5"},
      {:ex_doc, "~> 0.18", only: [:docs, :dev]},
      {:inch_ex, "~> 0.5", only: [:docs, :dev]}
    ]
  end

  defp package do
    %{
      licenses: ["MIT"],
      maintainers: ["Fredrik Enestad"],
      links: %{"GitHub" => @url}
    }
  end
end
