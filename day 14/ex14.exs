defmodule Ex14 do
  def get_final_pos({x,max_y},_,max_y), do: {x,max_y}

  def get_final_pos({start_x,start_y},stones,max_y) do
    cond do
      !MapSet.member?(stones,{start_x,start_y+1}) -> get_final_pos({start_x,start_y+1},stones,max_y)
      !MapSet.member?(stones,{start_x-1,start_y+1}) -> get_final_pos({start_x-1,start_y+1},stones,max_y)
      !MapSet.member?(stones,{start_x+1,start_y+1}) -> get_final_pos({start_x+1,start_y+1},stones,max_y)
      {start_x,start_y} == {500,0} -> :stuck
      true -> {start_x,start_y}
    end
  end

  def get_first_fall(stones,max_y) do
    new_stone = Ex14.get_final_pos({500,0},stones,max_y)
    case new_stone do
      {_,^max_y} -> 0
      res -> 1 + get_first_fall(MapSet.put(stones,res),max_y)
    end
  end

  def get_first_stuck(stones,max_y) do
    new_stone = Ex14.get_final_pos({500,0},stones,max_y)
    case new_stone do
      :stuck -> 1
      res -> 1 + get_first_stuck(MapSet.put(stones,res),max_y)
    end
  end
end

data = File.stream!("ex14.txt")
|>Enum.map(&String.trim/1)
|>Enum.map(fn line -> line
  |>String.split(" -> ")
  |>Enum.map(fn coord -> coord
    |>String.split(",")
    |>Enum.map(&String.to_integer/1)
    |>List.to_tuple()
  end)
end)

max_y = data
|>Enum.map(fn line -> line
  |>Enum.map(fn {_,y} -> y end)
end)
|>List.flatten()
|>Enum.max()

stones = data
|>Enum.reduce(MapSet.new([]),fn lines,acc ->
  new_stones = lines
  |>Enum.with_index()
  |>Enum.reduce_while([], fn {{x,y},index},a ->
    cond do
      length(lines) == index + 1 -> {:halt, a}
      true -> {next_x,next_y} = Enum.at(lines,index + 1)
        cond do
          next_x == x -> {:cont, a ++ Enum.map(y..next_y,fn num -> {x,num} end)}
          next_y == y -> {:cont, a ++ Enum.map(x..next_x,fn num -> {num,y} end)}
          true -> {:cont, a}
        end
    end
  end)
  |>MapSet.new()
  MapSet.union(acc,new_stones)
end)

solution1 = Ex14.get_first_fall(stones,max_y)
solution2 = Ex14.get_first_stuck(stones,max_y+1)

IO.inspect(solution1)
IO.inspect(solution2)
