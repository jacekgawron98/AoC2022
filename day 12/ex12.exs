defmodule Ex12 do
  def find_coords(char, grid) do
    Enum.with_index(grid)
    |>Enum.reduce([], fn {line,y}, acc ->
      data = Enum.with_index(line)
      |>Enum.reduce([], fn {c,x}, acc ->
        cond do
          String.equivalent?(c,char) -> acc ++ [{x,y}]
          true -> acc
        end
      end)
      acc ++ data
    end)
  end

  def get_size(graph) do
    {length(Enum.at(graph,0)),length(graph)}
  end

  def get_value(char) do
    case char do
      "E" -> 26
      "S" -> 1
      _ -> (char |> String.to_charlist |> hd) - 96
    end
  end

  def bfs([],_,_,_), do: nil
  def bfs([{coord, count} | _],_,coord,_), do: count
  def bfs([{coord, count} | tail],visited, target, {grid,grid_x,grid_y}) do
    next_coords = get_next_coords(coord,visited,{grid,grid_x,grid_y})
    coords_with_count = next_coords
    |>Enum.map(fn coord -> {coord, count + 1} end)
    new_queue = tail ++ coords_with_count
    bfs(new_queue,MapSet.union(visited,MapSet.new(next_coords)),target,{grid,grid_x,grid_y})
  end

  def get_next_coords({coord_x,coord_y},visited,{grid,grid_x,grid_y}) do
    val = get_value(Enum.at(Enum.at(grid,coord_y),coord_x))
    [{0,-1},{0,1},{-1,0},{1,0}]
    |>Enum.map(fn {x,y} -> {coord_x + x, coord_y + y} end)
    |>Enum.reduce([], fn {x,y},acc ->
      cond do
        x < 0 or y < 0 or x >= grid_x or y >= grid_y -> acc
        get_value(Enum.at(Enum.at(grid,y),x)) - val <= 1 -> acc ++ [{x,y}]
        true -> acc
      end
    end)
    |>Enum.filter(fn next -> !MapSet.member?(visited,next) end)
  end
end


data = File.stream!("ex12.txt")
|>Enum.map(&String.trim/1)
|>Enum.map(&String.graphemes/1)

{x,y} = Ex12.get_size(data)
[start_coords] = Ex12.find_coords("S",data)
[end_coords] = Ex12.find_coords("E",data)

solution1 = Ex12.bfs([{start_coords,0}],MapSet.new([start_coords]),end_coords,{data,x,y})
solution2 = Ex12.find_coords("a",data) ++ [start_coords]
|>Enum.map(fn coord ->
  Ex12.bfs([{coord,0}],MapSet.new([coord]),end_coords,{data,x,y})
end)
|>Enum.filter(fn res -> res != nil end)
|>Enum.min()

IO.inspect(solution1)
IO.inspect(solution2)
