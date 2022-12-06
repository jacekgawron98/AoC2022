defmodule Ex6 do
  def detect_distinct(len \\ 4) do
    elem(File.read("ex6.txt"),1)
    |>String.graphemes()
    |>Enum.with_index()
    |>Enum.reduce_while("", fn {s,index},acc ->
      res = acc <> s
      |>(&(
        cond do
          String.length(&1) > len -> String.slice(&1,1,String.length(&1))
          true -> &1
        end
      )).()

      map = res
      |>String.graphemes()
      |>MapSet.new()

      cond do
        MapSet.size(map) == len -> {:halt, index + 1}
        true -> {:cont, res}
      end
    end)
  end
end

IO.inspect(Ex6.detect_distinct())
IO.inspect(Ex6.detect_distinct(14))
