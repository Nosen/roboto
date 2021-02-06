defmodule Roboto.Command do
  use Agent
  alias Roboto.{State, Position}

  @table_min 0
  @table_max 5

  @right_map %{:NORTH => :EAST, :EAST => :SOUTH, :SOUTH => :WEST, :WEST => :NORTH}
  @left_map Map.new(@right_map, fn {key, val} -> {val, key} end)



  def process_command_list([]) do
    {:error, "No place command found"}
  end

  def process_command_list(["place"| rest]) do
    []
  end

  def process_command_list(["move" | rest]) do
    []
  end

  def process_command_list(["left" | rest]) do
    []
  end

  def process_command_list(["right" | rest]) do
    []
  end

  def process_command_list(["report" | rest]) do
    []
  end

  def handle_place(x, y, z) when x >= @table_min and x <= @table_max and y >= @table_min and y <= @table_max and z in [:NORTH, :SOUTH, :EAST, :WEST] do
    State.update(%Position{x: x, y: y, orientation: z})
    {:ok}
  end

  def handle_place(_, _, _) do
    {:error, "Invalid coordinates"}
  end


  def handle_move() do
    state = State.get()
    if valid_move(state.x, state.y, state.orientation) do
      case state.orientation do
        :NORTH ->
          State.update(%Position{x: state.x, y: state.y + 1, orientation: state.orientation})
        :EAST ->
          State.update(%Position{x: state.x + 1, y: state.y, orientation: state.orientation})
        :SOUTH ->
          State.update(%Position{x: state.x, y: state.y - 1, orientation: state.orientation})
        :WEST ->
          State.update(%Position{x: state.x - 1, y: state.y, orientation: state.orientation})
      end
      {:ok}
    else
      {:error, "can't move from here. change orientation and try again"}
    end
  end

  def left(%Position{orientation: orientation} = position) do
    State.update(%Position{position | orientation: @left_map[orientation]})
  end

  def right(%Position{orientation: orientation} = position) do
    State.update(%Position{position | orientation: @right_map[orientation]})
  end

  def report() do
    s = State.get()
    IO.puts "#{s.x} #{s.y} #{s.orientation}"
  end

  defp valid_move(x, y, z) do
    case z do
      :NORTH when y + 1 <= @table_max ->true
      :EAST when x + 1 <= @table_max -> true
      :SOUTH when y - 1 >= @table_min -> true
      :WEST when x - 1 >= @table_min -> true
      _ -> false
    end

  end

end
