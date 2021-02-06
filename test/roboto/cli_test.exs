defmodule Roboto.CLITest do
  use ExUnit.Case
  doctest Roboto.CLI

  test "greets the world" do
    assert Roboto.CLI.hello() == :world
  end
end
