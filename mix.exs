defmodule Commander.Mixfile do
  use Mix.Project

  def project do
    [app: :commander,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    []
  end

  defp deps do
    [
      {:dialyxir, "~> 0.4", only: :dev, runtime: false}
    ]
  end
end
