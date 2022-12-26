defmodule Ex18 do
  def flood_fill(result, _, _, _, []), do: result
  def flood_fill(result, object, checked, {min_x,max_x,min_y,max_y,min_z,max_z}, [queue_head | queue_tail]) do
    {x,y,z} = queue_head
    new_c = checked ++ [{x,y,z}]
    {res,new_queue} = if Enum.member?(object,{x,y,z}) do
        {result,queue_tail}
    else
      new_res = result ++ [{x,y,z}]
      new = [{x-1,y,z},{x+1,y,z},{x,y-1,z},{x,y+1,z},{x,y,z-1},{x,y,z+1}]
      |>Enum.filter(fn {nx,ny,nz} ->
        nx >= min_x and nx <= max_x and ny >= min_y and ny <= max_y and nz >= min_z and nz <= max_z
      end)
      |>Enum.filter(fn pos -> !Enum.member?(result,pos) or !Enum.member?(checked,pos) end)

      new_q = queue_tail ++ new
      |>Enum.uniq()
      {new_res,new_q}
    end
    flood_fill(res,object,new_c,{min_x,max_x,min_y,max_y,min_z,max_z},new_queue)
  end
end

data = File.stream!("ex18.txt")
|>Enum.map(&String.trim/1)
|>Enum.map(&(String.split(&1,",")))
|>Enum.map(fn [x,y,z] ->
  {String.to_integer(x),String.to_integer(y),String.to_integer(z)}
end)

min_x = data |> Enum.map(fn {x,_,_} -> x end) |> Enum.min() |> Kernel.-(1)
max_x = data |> Enum.map(fn {x,_,_} -> x end) |> Enum.max() |> Kernel.+(1)
min_y = data |> Enum.map(fn {_,y,_} -> y end) |> Enum.min() |> Kernel.-(1)
max_y = data |> Enum.map(fn {_,y,_} -> y end) |> Enum.max() |> Kernel.+(1)
min_z = data |> Enum.map(fn {_,_,z} -> z end) |> Enum.min() |> Kernel.-(1)
max_z = data |> Enum.map(fn {_,_,z} -> z end) |> Enum.max() |> Kernel.+(1)

bounding_box = Ex18.flood_fill([],data,[],{min_x,max_x,min_y,max_y,min_z,max_z},[{0,0,0}])

solution1 = data
|>Enum.map(fn {x,y,z} ->
  visible_sides = data
  |>Enum.count(fn {next_x,next_y,next_z} ->
    (abs(next_x-x) == 1 and next_y-y == 0 and next_z-z == 0) or
    (next_x-x == 0 and abs(next_y-y) == 1 and next_z-z == 0) or
    (next_x-x == 0 and next_y-y == 0 and abs(next_z-z) == 1)
  end)
  6-visible_sides
end)
|>Enum.sum()

solution2 = bounding_box -- data
|>Enum.map(fn {x,y,z} ->
  visible_sides = data
  |>Enum.count(fn {next_x,next_y,next_z} ->
    (abs(next_x-x) == 1 and next_y-y == 0 and next_z-z == 0) or
    (next_x-x == 0 and abs(next_y-y) == 1 and next_z-z == 0) or
    (next_x-x == 0 and next_y-y == 0 and abs(next_z-z) == 1)
  end)
  visible_sides
end)
|>Enum.filter(fn s -> s != 0 end)
|>Enum.sum()

IO.inspect(solution1)
IO.inspect(solution2)
