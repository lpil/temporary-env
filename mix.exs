defmodule TemporaryEnv.Mixfile do
  use Mix.Project

  @version "1.0.0"

  def project do
    [
      app: :temporary_env,
      version: @version,
      elixir: "~> 1.0",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps
    ]
  end

  def application do
    [applications: []]
  end

  defp deps do
    [
      # Automatic test runner
      {:mix_test_watch, only: :dev},
      # Style linter
      {:dogma, only: :dev},

      # Markdown processor
      {:earmark, only: :dev},
      # Documentation generator
      {:ex_doc, only: :dev},
    ]
  end
end
