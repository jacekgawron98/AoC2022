contained = File.stream!("ex4.txt")
|>Enum.map(&String.trim/1)
|>Enum.map(fn pair ->
  String.split(pair, ",")
  |>Enum.map(fn p ->
    String.split(p, "-")
    |>Enum.map(&Integer.parse/1)
    |>Enum.map(&(elem(&1,0)))
  end)
end)
|>Enum.map(fn l ->
  first = Enum.at(l,0)
  second = Enum.at(l,1)
  cond do
    Enum.at(first,0) <= Enum.at(second,0) and Enum.at(first,1) >= Enum.at(second,1) -> 1
    Enum.at(second,0) <= Enum.at(first,0) and Enum.at(second,1) >= Enum.at(first,1) -> 1
    true -> 0
  end
end)
|>Enum.sum()

contained2 = File.stream!("ex4.txt")
|>Enum.map(&String.trim/1)
|>Enum.map(fn pair ->
  String.split(pair, ",")
  |>Enum.map(fn p ->
    String.split(p, "-")
    |>Enum.map(&Integer.parse/1)
    |>Enum.map(&(elem(&1,0)))
  end)
end)
|>Enum.map(fn l ->
  first = Enum.at(l,0)
  second = Enum.at(l,1)
  cond do
    Enum.at(first,0) <= Enum.at(second,1) and Enum.at(first,1) >= Enum.at(second,0) -> 1
    true -> 0
  end
end)
|>Enum.sum()

IO.inspect(contained)
IO.inspect(contained2)
