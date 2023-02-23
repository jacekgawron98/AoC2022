defmodule Ex6 do
  def detect_distinct1(data, index, len \\ 4) do
    res = Enum.slice(data,index,len)
    |>Enum.uniq()
    cond do
      length(res) == len -> index + len
      true -> detect_distinct1(data, index+1, len)
    end
  end
end

data = elem(File.read("ex6.txt"),1)
|>String.graphemes()
IO.inspect(Ex6.detect_distinct1(data,0))
IO.inspect(Ex6.detect_distinct1(data,0,14))
