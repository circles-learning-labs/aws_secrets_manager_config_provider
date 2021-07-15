defmodule AwsSsmConfigProviderTest do
  use ExUnit.Case
  doctest AwsSsmConfigProvider

  test "greets the world" do
    assert AwsSsmConfigProvider.hello() == :world
  end
end
