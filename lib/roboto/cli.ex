defmodule Roboto.CLI do
  @moduledoc """
  Documentation for `Roboto.CLI`.
  """

  alias Roboto.{Command, State}
  use Agent

  def main(_) do
   State.start_link()
   listen()
  end

  def listen do
    IO.gets("> ")
    |> String.trim
    |> String.downcase
    |> String.split(",")
    |> Enum.join(" ")
    |> String.split(" ", trim: true)
    |> Command.truncate_to_place_command
    |> Command.begin_command_loop
    |> case do
      {:error, reason} ->
        IO.puts "Error: #{reason}"
        listen()
      _ ->
        IO.puts "Commands processed successfully"
        listen()
      end

  end

end
