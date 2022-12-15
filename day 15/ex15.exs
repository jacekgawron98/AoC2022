defmodule Ex15 do
  def calculate_distance([p1,p2,q1,q2]) do
    abs(p1-q1) + abs(p2-q2)
  end

  def get_beacons_at_position(position, data) do
    data
    |>Enum.filter(fn [_,_,_,q2] -> q2 == position end)
    |>Enum.map(fn [_,_,q1,_] -> q1 end)
    |>Enum.uniq()
  end

  def get_sensor_coverage_at_position({p1,p2},max_distance,position) do
    left_side = (max_distance - abs(p2 - position))
    cond do
      left_side < 0 -> []
      true -> [-(left_side - p1),left_side + p1]
        |>Enum.sort()
    end
  end

  def get_ranges(y,data) do
    data
    |>Enum.reduce([], fn [p1,p2,q1,q2],acc ->
      max_distance = calculate_distance([p1,p2,q1,q2])
      case get_sensor_coverage_at_position({p1,p2},max_distance,y) do
        [] -> acc
        res -> acc ++ [res]
      end
    end)
    |>Enum.sort()
  end

  def merge_ranges(ranges) do
    ranges
    |>Enum.with_index()
    |>Enum.reduce([[0,0]], fn {[min,max],i},acc ->
      case i do
        0 -> [[min,max]]
        _ -> [prev_min,prev_max] = List.last(acc)
          cond do
            prev_max < min -> acc ++ [[min,max]]
            true -> List.update_at(acc,length(acc)-1,fn _ -> [prev_min,max(prev_max,max)] end)
          end
      end
    end)
  end
end

data = File.stream!("ex15.txt")
|>Enum.map(&String.trim/1)
|>Enum.map(fn line -> line
  |>String.split([": ", ", "])
  |>Enum.map(fn d -> d
    |>String.replace(~r/[^-\d]/, "")
    |>String.to_integer()
  end)
end)

y = 2000000
beacons_at_y = Ex15.get_beacons_at_position(y,data)

ranges = Ex15.get_ranges(y,data)
|>Ex15.merge_ranges()

diff = ranges
|>Enum.map(fn [min,max] ->
  Enum.reduce(beacons_at_y,0, fn q,acc ->
    cond do
      q < max and q > min -> acc + 1
      true -> acc
    end
  end)
end)
|>Enum.at(0)
ranges_sum = ranges
|>Enum.map(fn [min,max] -> max-min+1 end)
|>Enum.at(0)

solution1 = ranges_sum - diff

solution2 = 0..4000000
|>Enum.reduce_while([],fn new_y,_ ->
  new_ranges = Ex15.get_ranges(new_y,data)
  |>Enum.map(fn [min,max] ->
    [max(0,min),min(4000000,max)]
  end)
  case Ex15.merge_ranges(new_ranges) do
    res when length(res) == 1 -> {:cont, []}
    [[_,data]|_] -> {:halt, (data + 1)*4000000 + new_y}
  end
end)

IO.inspect(solution1)
IO.inspect(solution2)
