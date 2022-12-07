defmodule Ex7 do
  def get_sum(dir_map, dir) do
    Map.get(dir_map,dir)
    |>Enum.group_by(&is_integer/1)
    |>Enum.reduce(0, fn data,acc ->
      {type, d} = data
      case type do
        false -> acc + Enum.reduce(d,0,fn dir_to_check,a ->
          a + get_sum(dir_map,dir_to_check)
        end)
        true -> acc + Enum.sum(d)
      end
    end)
  end
end

data = File.stream!("ex7.txt")
|>Enum.map(&String.trim/1)
|>Enum.map(&(String.split(&1," ")))
|>Enum.reduce({[],%{}},fn [first | tail], {cur_dir, dirs_map} ->
  case first do
    "$" ->
      case Enum.at(tail,0) do
        "cd" -> case Enum.at(tail,1) do
          ".." -> {List.delete_at(cur_dir, length(cur_dir)-1),dirs_map}
          _ -> {cur_dir ++ [Enum.at(tail,1)], Map.put(dirs_map, Enum.join(cur_dir ++ [Enum.at(tail,1)],"-"), [])}
        end
        "ls" -> {cur_dir, dirs_map}
      end
    "dir" -> {cur_dir, Map.update!(dirs_map, Enum.join(cur_dir,"-"), &(
      &1 ++ [Enum.join(cur_dir ++ [Enum.at(tail,0)],"-")]))}
    f -> {cur_dir, Map.update!(dirs_map, Enum.join(cur_dir,"-"), &(
      &1 ++ [elem(Integer.parse(f),0)]
    ))}
  end
end)
|>elem(1)

mapped = Enum.map(data, fn e ->
  {dir, _} = e
  {dir, Ex7.get_sum(data, dir)}
end)

ans1 = mapped
|>Enum.filter(fn {_, size} -> size <= 100000 end)
|>Enum.reduce(0, fn {_,size},acc -> acc + size end)

{_,root_size} = Enum.find(mapped, -1, fn {k,_} -> String.equivalent?(k,"/") end)
free_space = 70000000 - root_size
ans2 = Enum.filter(mapped, fn {_, size} -> size >= (30000000 - free_space) end)
|>Enum.map(fn {_,size} -> size end)
|>Enum.min()

IO.inspect(ans1)
IO.inspect(ans2)
