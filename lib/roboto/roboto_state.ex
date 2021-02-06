defmodule Roboto.State do
  @moduledoc """
      Struct to represent simulation state
  """

  use Agent

  alias Roboto.{Position}

  @module __MODULE__

  def start_link() do
    Agent.start_link(fn -> %Position{} end, name: @module)
  end

  def update(state) do
    Agent.update(@module, &(&1 = state))
  end

  def get() do
    Agent.get(@module, & &1)
  end

end
