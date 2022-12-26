defmodule Ex17 do
  def get_new_rock(rocks, height, cur_rock) do
    rocks
    |>Enum.at(cur_rock)
    |>Enum.map(fn {h,val} -> {h+height,val} end)
  end

  def shift_rock(rock, dir) do
    case dir do
      "<" -> rock
      |>Enum.map(fn {h,val} -> {h, Bitwise.bsl(val,1)} end)
      ">" -> rock
      |>Enum.map(fn {h,val} -> {h, Bitwise.bsr(val,1)} end)
    end
  end

  def get_next_move(moves,next_move) do
    rem(next_move,length(moves))
  end

  def check_collision(rock, map) do
    rock
    |>Enum.map(fn {h,val} ->
      in_map = Enum.find(map,nil,fn {h_map,_} -> h_map == h end)
      case in_map do
        nil -> Bitwise.band(val,0b100000001)
        {_,val_map} -> Bitwise.band(val,val_map)
      end
    end)
    |>Enum.filter(fn val -> val != 0 end)
    |>length()
    |>Kernel.!=(0)
  end

  def move_down(rock) do
    rock
    |>Enum.map(fn {h,val} -> {h-1,val} end)
  end

  def move_rock(rock, map, moves, next_move) do
    #IO.inspect(rock, base: :binary)
    shifted_rock = shift_rock(rock, Enum.at(moves,next_move))
    case check_collision(shifted_rock,map) do
      false -> down_moved_rock = move_down(shifted_rock)
        case check_collision(down_moved_rock,map) do
          false -> {moves,new_rock} = move_rock(down_moved_rock,map,moves,get_next_move(moves,next_move+1))
            {1 + moves, new_rock}
          true -> {1,shifted_rock}
        end
      true -> down_moved_rock = move_down(rock)
        case check_collision(down_moved_rock,map) do
          false -> {moves,new_rock} = move_rock(down_moved_rock,map,moves,get_next_move(moves,next_move+1))
            {1 + moves, new_rock}
          true -> {1,rock}
        end
    end
  end

  def init_cache(value) do
    Agent.start_link(fn -> value end, name: :cache)
  end

  def update_cache(key,val) do
    Agent.update(:cache,fn map -> Map.put(map, key, val) end)
  end

  def get_value_from_cache(key) do
    Agent.get(:cache, fn map -> Map.get(map,key) end)
  end

  def get_cache() do
    Agent.get(:cache, fn map -> map end)
  end
end

data = File.stream!("ex17.txt")
|>Enum.at(0)
|>String.trim()
|>String.graphemes()

rocks = [
  [{0,0b000111100}],
  [{0,0b000010000},{1,0b000111000},{2,0b000010000}],
  [{0,0b000111000},{1,0b000001000},{2,0b000001000}],
  [{0,0b000100000},{1,0b000100000},{2,0b000100000},{3,0b000100000}],
  [{0,0b000110000},{1,0b000110000}]
]

map = [{0,0b111111111}]

Ex17.init_cache(%{})
solution1 = 0..2021
#solution1 = 0..5000
|>Enum.reduce({4,map,0},fn r, {height,cur_map,next_move} ->
  cur_rock = rem(r,5)
      {moves,new_rock} = Ex17.move_rock(Ex17.get_new_rock(rocks,height,cur_rock),cur_map,data,next_move)
      new_rock_with_walls = new_rock
      |>Enum.map(fn {h,val} -> {h,Bitwise.bor(val,0b100000001)} end)
      new_move = Ex17.get_next_move(data,moves + next_move)
      new_map = cur_map ++ new_rock_with_walls
      |>Enum.reduce([], fn {h,val},acc ->
        case Enum.find_index(acc, fn {a,_} -> a == h end) do
          nil -> acc ++ [{h,val}]
          i -> List.update_at(acc,i, fn {_,map_val} -> {h, Bitwise.bor(map_val,val)} end)
        end
      end)
      new_height = new_map |> Enum.map(fn {h,_} -> h end)
      |>Enum.max()
      |>Kernel.+(4)

      new_map = Enum.take(new_map,-50)

      last_elems = new_map
      |>Enum.map(fn {_,l} -> l end)
      Ex17.update_cache({cur_rock,next_move,last_elems},{new_height,new_map,new_move})
      {new_height,new_map,new_move}
end)
|>elem(1)
|>Enum.map(fn {h,_} -> h end)
|>Enum.max()

IO.inspect(solution1)
