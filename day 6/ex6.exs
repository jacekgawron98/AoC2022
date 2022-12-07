defmodule Ex6 do
  def detect_distinct(len \\ 4) do
    elem(File.read("ex6.txt"),1)
    |>String.graphemes()
    |>(fn list -> Enum.with_index(list)
      |>Enum.reduce_while("",
      fn {s,index},acc ->
        res = Enum.slice(list,index,len)
        |>Enum.uniq()
        |>(&(
          cond do
            length(&1) == len -> {:halt, index + len}
            true -> {:cont, ""}
          end
        )).()
      end)
    end).()
  end
end

IO.inspect(Ex6.detect_distinct())
IO.inspect(Ex6.detect_distinct(14))
