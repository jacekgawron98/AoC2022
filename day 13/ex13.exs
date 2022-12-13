defmodule Ex13 do
  def compare_packets([packet1, packet2]) do
    result = Enum.with_index(packet1)
    |>Enum.reduce_while(true, fn {left_elem,index},_ ->
      right_elem = Enum.at(packet2,index)
      cond do
        right_elem == nil -> {:halt, :false}
        is_integer(left_elem) and is_integer(right_elem) and left_elem > right_elem -> {:halt, :false}
        is_integer(left_elem) and is_integer(right_elem) and left_elem < right_elem -> {:halt, :true}
        is_integer(left_elem) and is_integer(right_elem) and left_elem == right_elem -> {:cont, :unknown}
        is_list(left_elem) and is_list(right_elem) -> case compare_packets([left_elem,right_elem]) do
          :unknown -> {:cont, :unknown}
          res -> {:halt, res}
        end
        !is_list(left_elem) and is_list(right_elem) -> case compare_packets([[left_elem],right_elem]) do
          :unknown -> {:cont, :unknown}
          res -> {:halt, res}
        end
        is_list(left_elem) and !is_list(right_elem) -> case compare_packets([left_elem,[right_elem]]) do
          :unknown -> {:cont, :unknown}
          res -> {:halt, res}
        end
        true -> {:cont, :true}
      end
    end)
    case result do
      :unknown when length(packet1) < length(packet2) -> true
      :unknown -> :unknown
      res -> res
    end
  end
end

data = elem(File.read("ex13.txt"),1)
|>String.split("\n\n")
|>Enum.map(fn test ->
  String.split(test,"\n")
  |>Enum.map(fn packet -> Code.eval_string(packet)
    |>elem(0)
  end)
end)

solution1 = Enum.map(data,fn packets ->
  Ex13.compare_packets(packets)
end)
|>Enum.with_index(1)
|>Enum.filter(fn {data,_} -> data == true end)
|>Enum.map(fn {_,index} -> index end)
|>Enum.sum()

solution2_data = List.foldl(data, [], fn packets, acc -> acc ++ packets end)
|>(&(&1 ++ [[[2]],[[6]]])).()
|>Enum.sort(fn p1,p2 -> Ex13.compare_packets([p1,p2]) end)
div1 = Enum.find_index(solution2_data, fn d -> d == [[2]] end) + 1
div2 = Enum.find_index(solution2_data, fn d -> d == [[6]] end) + 1
solution2 =  div1 * div2

IO.inspect(solution1, charlists: :as_lists)
IO.inspect(solution2, charlists: :as_lists)
