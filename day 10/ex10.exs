data = File.stream!("ex10.txt")
|>Enum.map(&String.trim/1)
|>Enum.map(&String.split/1)
|>Enum.map(fn input ->
  cond do
    length(input) == 2 -> {val, _} = Integer.parse(Enum.at(input,1))
      {Enum.at(input,0),val}
    true -> {Enum.at(input,0),0}
  end
end)
|>Enum.reduce([{1,1}], fn {command,val}, acc ->
  {last_cycle,last_val} = List.last(acc)
  case command do
    "noop" -> acc ++ [{last_cycle + 1, last_val}]
    "addx" -> acc ++ [{last_cycle + 1, last_val},{last_cycle + 2, last_val + val},]
  end
end)

solution1 = [Enum.at(data,19),Enum.at(data,59),Enum.at(data,99),Enum.at(data,139),Enum.at(data,179),Enum.at(data,219)]
|>Enum.map(fn {cycle,val} ->
  cycle * val
end)
|>Enum.sum()

screen_start = Enum.map(1..240,fn _ -> "." end)
solution2 = Enum.reduce(data, screen_start, fn {cycle, pos}, screen ->
  row = trunc(cycle/40)
  {s1,s2,s3} = {pos+row*40,pos+1+row*40,pos+2+row*40}
  cond do
    cycle == s1 or cycle == s2 or cycle == s3 -> List.update_at(screen,cycle-1,fn _ -> "#" end)
    true -> screen
  end
end)
|>Enum.chunk_every(40)
|>Enum.map(fn row -> Enum.join(row) end)


IO.inspect(solution1)
IO.inspect(solution2)
