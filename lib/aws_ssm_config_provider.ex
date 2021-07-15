defmodule AWSSSMConfigProvider do
  @behaviour Config.Provider

  @moduledoc """
  Documentation for `AwsSsmConfigProvider`.
  """

  def init(_), do: :ok

  def load(config, _) do
    {:ok, _} = Application.ensure_all_started(:hackney)
    {:ok, _} = Application.ensure_all_started(:ex_aws_ssm)

    Config.Reader.merge(config, resolve_secrets(config))
  end

  def resolve_secrets(config) do
    Enum.map(config, &eval_secret(&1, config))
  end

  defp eval_secret({:ssm_secret, path}, _config) do
    fetch_parameter(path)
  end

  defp eval_secret({key, val}, config) do
    {key, eval_secret(val, config)}
  end

  defp eval_secret(val, config) when is_list(val), do: Enum.map(val, &eval_secret(&1, config))

  defp eval_secret(other, _config), do: other

  defp fetch_parameter(path) do
    path
    |> ExAws.SSM.get_parameter(with_decryption: true)
    |> ExAws.request!()
    |> case do
      %{"Parameter" => %{"Value" => secret}} ->
        secret

      error ->
        raise ArgumentError, "secret at #{path} returned #{inspect(error)}"
    end
  end
end
