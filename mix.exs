defmodule TemporaryEnv.Mixfile do
  use Mix.Project

  @version "1.0.1"

  def project do
    [
      app: :temporary_env,
      version: @version,
      elixir: "~> 1.0",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps,

      name: "TemporaryEnv",
      source_url: "https://github.com/lpil/temporary-env",
      description: "A tool for managing application env state within tests.",
      package: [
        maintainers: ["Louis Pilfold"],
        licenses: ["MIT"],
        links: %{ "github" => "https://github.com/lpil/temporary-env" },
      ]
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
      {:dogma, only: [:dev, :test]},

      # Markdown processor
      {:earmark, only: :dev},
      # Documentation generator
      {:ex_doc, only: :dev},
    ]
  end
end
