defmodule Ex3 do
  def convert_char_to_score(char) do
    case char do
      n when n >= 65 and n <= 90 -> n - 38
      n when n >= 97 and n <= 122 -> n - 96
      _ -> 0
    end
  end
end

priorities = File.stream!("ex3.txt")
|>Enum.map(&String.trim/1)
|>Enum.map(fn line ->
  character = String.split_at(line, trunc(String.length(line)/2))
  |>Tuple.to_list()
  |>Enum.map(&String.to_charlist/1)
  |>(fn l ->
    Enum.at(l,0) -- Enum.at(l,1)
    |>(&(Enum.at(l,0) -- &1)).()
    |>Enum.at(0)
  end).()
  |>Ex3.convert_char_to_score()
end)
|>Enum.sum()

priorities2 = File.stream!("ex3.txt")
|>Enum.map(&String.trim/1)
|>Enum.chunk_every(3)
|>Enum.map(fn group ->
  group
  |>Enum.map(&String.to_charlist/1)
  |>Enum.map(&MapSet.new/1)
  |>(&(MapSet.intersection(Enum.at(&1,0),Enum.at(&1,1))
    |>MapSet.intersection(Enum.at(&1,2))
  )).()
  |>MapSet.to_list()
  |>Enum.at(0)
  |>(&(Ex3.convert_char_to_score(&1))).()
end)
|>Enum.sum()

IO.inspect(priorities)
IO.inspect(priorities2)
