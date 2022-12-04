contained = File.stream!("ex4.txt")
|>Enum.map(fn pair ->
  String.split(pair, [",","-"])
  |>Enum.map(&Integer.parse/1)
  |>Enum.map(&(elem(&1,0)))
end)
|>Enum.map(fn [startA,endA,startB,endB] ->
  cond do
    startA <= startB and endA >= endB -> 1
    startB <= startA and endB >= endA -> 1
    true -> 0
  end
end)
|>Enum.sum()

contained2 = File.stream!("ex4.txt")
|>Enum.map(fn pair ->
  String.split(pair, [",","-"])
  |>Enum.map(&Integer.parse/1)
  |>Enum.map(&(elem(&1,0)))
end)
|>Enum.map(fn [startA,endA,startB,endB] ->
  cond do
    startA <= endB and endA >= startB -> 1
    true -> 0
  end
end)
|>Enum.sum()

IO.inspect(contained)
IO.inspect(contained2)
