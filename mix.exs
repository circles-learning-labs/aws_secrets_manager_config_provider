defmodule AwsSecretsManagerConfigProvider.MixProject do
  use Mix.Project

  def project do
    [
      app: :aws_secrets_manager_config_provider,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    []
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_aws, "~> 2.1"},
      {:ex_aws_secretsmanager, "~> 2.0"},
      {:jason, "~> 1.2"}
    ]
  end
end
