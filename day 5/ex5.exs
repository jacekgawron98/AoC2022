data = File.stream!("ex5.txt")
|>Enum.chunk_by(&(&1 == "\n"))

storage = Enum.at(data,0)
|>Enum.map(&(String.replace(&1,"\n","")))
|>Enum.reverse()
|>tl()
|>Enum.map(fn stor ->
  String.replace(stor, "[", "")
  |>String.replace("]","")
  |>String.replace("    "," ")
  |>String.split(" ")
end)
|>List.zip
|>Enum.map(&Tuple.to_list/1)
|>Enum.map(fn e ->
  Enum.filter(e, fn elem -> !String.equivalent?(elem, "")  end)
end)

moves = Enum.at(data,2)
|>Enum.map(&String.trim/1)
|>Enum.map(fn move ->
  [_ | tail] = String.split(move, ["move "," from ", " to "])
  tail
  |>Enum.map(&Integer.parse/1)
  |>Enum.map(&(elem(&1,0)))
end)

last = moves
|>Enum.reduce(storage, fn move,acc ->
  [count, origin, source] = move
  origin_data = Enum.at(acc,origin-1)
  source_data = Enum.at(acc,source-1)
  change = Enum.take(origin_data,-count)
  List.replace_at(acc, origin-1, Enum.take(origin_data,length(origin_data)-count))
  |>List.replace_at(source-1, source_data ++ Enum.reverse(change))
end)
|>Enum.map(&(List.last(&1)))
|>Enum.reduce("", &(&2 <> &1))

last2 = moves
|>Enum.reduce(storage, fn move,acc ->
  [count, origin, source] = move
  origin_data = Enum.at(acc,origin-1)
  source_data = Enum.at(acc,source-1)
  change = Enum.take(origin_data,-count)
  List.replace_at(acc, origin-1, Enum.take(origin_data,length(origin_data)-count))
  |>List.replace_at(source-1, source_data ++ change)
end)
|>Enum.map(&(List.last(&1)))
|>Enum.reduce("", &(&2 <> &1))

IO.inspect(last)
IO.inspect(last2)
