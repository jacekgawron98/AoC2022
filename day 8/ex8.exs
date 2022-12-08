defmodule Ex8 do
  def get_dimensions (data) do
    {length(Enum.at(data,0)),length(data)}
  end
end

data = File.stream!("ex8.txt")
|>Enum.map(&(String.trim(&1)
  |>String.graphemes()
  |>Enum.map(fn a -> Integer.parse(a)
    |>elem(0)
  end)))

columns = List.zip(data)
|>Enum.map(&Tuple.to_list/1)

{x,y} = Ex8.get_dimensions(data)

res = Enum.with_index(data)
|>Enum.map(fn {row, ri} ->
  Enum.with_index(row)
  |>Enum.map(fn {tree, ci} ->
    cond do
      ci-1 < 0 or ri-1 < 0 or ci+1 == x or ri+1 == y -> "V"
      true -> (
        top = Enum.slice(Enum.at(columns,ci),0,ri)
        bottom = Enum.slice(Enum.at(columns,ci),ri+1,y+1)
        left = Enum.slice(Enum.at(data,ri),0,ci)
        right = Enum.slice(Enum.at(data,ri),ci+1,x+1)
        cond do
          Enum.all?(top, fn t -> tree > t end)
            or Enum.all?(bottom, fn t -> tree > t end)
            or Enum.all?(left, fn t -> tree > t end)
            or Enum.all?(right, fn t -> tree > t end) -> "V"
          true -> "N"
        end
      )
    end
  end)
end)
|>List.flatten()
|>Enum.filter(fn t -> t == "V" end)
|>length()

res2 = Enum.with_index(data)
|>Enum.map(fn {row, ri} ->
  Enum.with_index(row)
  |>Enum.map(fn {tree, ci} ->
    cond do
      ci-1 < 0 or ri-1 < 0 or ci+1 == x or ri+1 == y -> 0
      true -> (
        top = Enum.slice(Enum.at(columns,ci),0,ri)
        bottom = Enum.slice(Enum.at(columns,ci),ri+1,y+1)
        left = Enum.slice(Enum.at(data,ri),0,ci)
        right = Enum.slice(Enum.at(data,ri),ci+1,x+1)
        top_score = Enum.reverse(top)
        |> Enum.reduce_while(0, fn t,acc -> cond do
            t >= tree -> {:halt, acc + 1}
            true -> {:cont, acc + 1}
          end
        end)
        bot_score = Enum.reduce_while(bottom,0, fn t,acc -> cond do
            t >= tree -> {:halt, acc + 1}
            true -> {:cont, acc + 1}
          end
        end)
        left_score = Enum.reverse(left)
        |> Enum.reduce_while(0, fn t,acc -> cond do
            t >= tree -> {:halt, acc + 1}
            true -> {:cont, acc + 1}
          end
        end)
        right_score = Enum.reduce_while(right,0, fn t,acc -> cond do
            t >= tree -> {:halt, acc + 1}
            true -> {:cont, acc + 1}
          end
        end)
        top_score * bot_score * left_score * right_score
      )
    end
  end)
end)
|>List.flatten()
|>Enum.max()

IO.inspect(res)
IO.inspect(res2)
