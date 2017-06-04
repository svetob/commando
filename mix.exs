defmodule Commander.Mixfile do
  use Mix.Project

  def project do
    [app: :commander,
     version: "0.1.0",
     elixir: "~> 1.4",
     description: description(),
     package: package(),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    []
  end

  defp deps do
    [
      {:dialyxir, "~> 0.4", only: :dev, runtime: false},
      {:ex_doc, "~> 0.11", only: :dev, runtime: false}
    ]
  end

  defp description do
    """
     Elixir command line options parser with descriptions, help messages,
     default values, and other useful features
    """
  end

  defp package do
    [
      name: :commander,
      maintainers: ["Tobias Ara Svensson"],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/svetob/commander"},
    ]
  end
end
