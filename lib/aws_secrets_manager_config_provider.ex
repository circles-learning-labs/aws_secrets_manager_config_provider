defmodule AWSSecretsManagerConfigProvider do
  @behaviour Config.Provider

  @moduledoc """
  Documentation for `AwsSecretsManagerConfigProvider`.
  """

  def init(_), do: :ok

  def load(config, _) do
    {:ok, _} = Application.ensure_all_started(:hackney)
    {:ok, _} = Application.ensure_all_started(:ex_aws_secretsmanager)

    Config.Reader.merge(config, resolve_secrets(config))
  end

  def resolve_secrets(config) do
    Enum.map(config, &eval_secret(&1, config))
  end

  defp eval_secret({:aws_secret, path, key}, _config) do
    fetch_parameter(path, key)
  end

  defp eval_secret({key, val}, config) do
    {key, eval_secret(val, config)}
  end

  defp eval_secret(val, config) when is_list(val), do: Enum.map(val, &eval_secret(&1, config))

  defp eval_secret(other, _config), do: other

  defp fetch_parameter(path, key) do
    request = ExAws.SecretsManager.get_secret_value(path)

    with {:ok, %{"SecretString" => json}} <- ExAws.request(request),
         {:ok, result} <- Jason.decode(json) do
      Map.get(result, key)
    else
      error ->
        raise ArgumentError, "secret at #{path}, #{key} returned #{inspect(error)}"
    end
  end
end
