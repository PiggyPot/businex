defmodule Businex.Mixfile do
  use Mix.Project

  def project do
    [
      app: :businex,
      version: "0.1.0",
      elixir: "~> 1.6",
      description: "Elixir business day calculations",
      package: package(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :yaml_elixir, :timex],
      mod: {Businex, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:yaml_elixir, "~> 1.3.1"},
      {:timex, "~> 3.1"},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp package() do
    [
      maintainers: ["Phil McClure"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/PiggyPot/businex"}
    ]
  end
end
