defmodule Ex16 do
  import Bitwise

  def bfs([],_,_,_), do: nil
  def bfs([{valve, count} | _],_,valve,_), do: {valve, count}
  def bfs([{valve, count} | tail],visited, target,all_valves) do
    next_valves = Enum.find(all_valves,[], fn {v,_,_} -> v == valve end)
    |>elem(2)
    |>Kernel.--(MapSet.to_list(visited))
    valves_with_count = next_valves
    |>Enum.map(fn valve -> {valve, count + 1} end)
    new_queue = tail ++ valves_with_count
    bfs(new_queue,MapSet.union(visited,MapSet.new(next_valves)),target, all_valves)
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

  def get_index(paths,key) do
    paths
    |>Map.to_list()
    |>Enum.find_index(fn {v,_} -> v == key end)
    |>Kernel.-(1)
  end

  def dfs(valve,rem_time,bitmask,paths,data) do
    case get_value_from_cache({valve,rem_time,bitmask}) do
      nil -> Map.get(paths,valve)
      |>Enum.reduce(0,fn {val,dist},acc ->
        bit = 1 <<< get_index(paths,val)
        case bitmask &&& bit do
          0 -> case rem_time - dist - 1 do
            new_rem when new_rem <= 0 -> acc
            new_rem -> a = Enum.find(data, nil, fn {v,_,_} -> v == val end) |> elem(1)
            new_acc = max(acc, dfs(val, new_rem, bitmask ||| bit,paths,data) + a * new_rem)
            update_cache({valve,rem_time,bitmask},new_acc)
            new_acc
          end
          _ -> acc
        end
      end)
      res -> res
    end
  end
end

data = File.stream!("ex16.txt")
|>Enum.map(&String.trim/1)
|>Enum.map(&(String.replace(&1,"Valve ", "")))
|>Enum.map(&(String.replace(&1," has flow rate=", ";")))
|>Enum.map(&(String.replace(&1," tunnel leads to valve ", "")))
|>Enum.map(&(String.replace(&1," tunnels lead to valves ", "")))
|>Enum.map(&(String.split(&1,";")))
|>Enum.map(fn [valve,rate,neighbours] -> {valve,String.to_integer(rate), String.split(neighbours,", ")} end)

keys = data
|>Enum.filter(fn {_,r,_} -> r != 0 end)
|>Enum.map(fn {v,_,_} -> v end)

paths = data
|>Enum.filter(fn {valve,_,_} -> Enum.member?(keys,valve) or valve == "AA" end)
|>Enum.map(fn {valve,_,_} ->
  {valve, Enum.map(keys, fn v -> Ex16.bfs([{valve,0}],MapSet.new([valve]),v,data) end)}
end)
|>Map.new()

Ex16.init_cache(%{})
solution1 = Ex16.dfs("AA",30,0,paths,data)

all_open_state = Bitwise.bsl(1,length(keys)+1) - 1
range_max = trunc((all_open_state+1)/2)
solution2 = Enum.map(0..range_max, fn state ->
  Ex16.dfs("AA",26,state,paths,data) + Ex16.dfs("AA",26,all_open_state-state,paths,data)
end)
|>Enum.max()

IO.inspect(solution1)
IO.inspect(solution2)
