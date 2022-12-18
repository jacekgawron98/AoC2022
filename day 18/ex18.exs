data = File.stream!("ex18.txt")
|>Enum.map(&String.trim/1)
|>Enum.map(&(String.split(&1,",")))
|>Enum.map(fn [x,y,z] ->
  {String.to_integer(x),String.to_integer(y),String.to_integer(z)}
end)

mapped = data
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

IO.inspect(mapped)
