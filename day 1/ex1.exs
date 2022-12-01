calories_on_elf = elem(File.read("ex1.txt"),1)
|> String.split("\n\n")
|> Enum.map(&(String.split(&1, "\n")))
|> Enum.map(&(List.foldl(&1, 0, fn x,acc ->
  case Integer.parse(x) do
    {parsed, _} -> acc + parsed
    :error -> acc
  end
end )))
|> Enum.sort(:desc)
|> Enum.take(3)
IO.puts(Enum.max(calories_on_elf))
IO.puts(Enum.sum(calories_on_elf))
