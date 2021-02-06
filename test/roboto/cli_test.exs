defmodule Roboto.CLITest do
  use ExUnit.Case
  doctest Roboto.CLI

  import ExUnit.CaptureIO

  alias Roboto.{State, Position, Command}

  test "greets the world" do
    assert Roboto.CLI.hello() == :world
  end

  test "place - allows place commands where x,y is in table bounds and orientation is valid" do
    State.start_link()
    assert {:ok} = Command.handle_place(1, 2, :NORTH)
    assert {:ok} = Command.handle_place(5, 5, :WEST)
    assert {:ok} = Command.handle_place(2, 5, :EAST)
    assert {:ok} = Command.handle_place(0, 0, :SOUTH)
  end

  test "place - returns error on place command with unknown orientation" do
    State.start_link()
    assert {:error,_} = Command.handle_place(1, 2, :UP)
  end

  test "place - returns error on place command with x or y exceeding table bounds" do
    State.start_link()
    assert {:error,_} = Command.handle_place(7, 7, :SOUTH)
    assert {:error,_} = Command.handle_place(-1, 6, :SOUTH)
  end

  test "move - allows movement where moving 1 space in current orientation won't exceed table bounds" do
    State.start_link()
    State.update(%Position{x: 1, y: 2, orientation: :NORTH})
    assert {:ok} = Command.handle_move()
  end

  test "move - returns an error where move command would send robot outside table bounds" do
    State.start_link()
    State.update(%Position{x: 1, y: 5, orientation: :NORTH})
    assert {:error, _} = Command.handle_move()
    State.update(%Position{x: 5, y: 0, orientation: :EAST})
    assert {:error, _} = Command.handle_move()
  end

  test "right - moves orientation 90 degrees clockwise" do
    State.start_link()
    State.update(%Position{x: 1, y: 5, orientation: :NORTH})
    s = State.get()
    Command.right(s)
    x = State.get()
    assert :EAST = x.orientation
  end

  test "left - moves orientation 90 degrees counter - clockwise" do
    State.start_link()
    State.update(%Position{x: 1, y: 5, orientation: :NORTH})
    s = State.get()
    Command.left(s)
    x = State.get()
    assert :WEST = x.orientation
  end


  test "report" do
    State.start_link()
    x = 1
    y = 5
    orientation = :NORTH
    State.update(%Position{x: x, y: y, orientation: orientation})
    assert capture_io(fn -> Command.report end) =~ "#{x} #{y} #{orientation}"
  end

end
