defmodule Ex11 do
  def get_int(str) do
    case Integer.parse(str) do
      {int, _} -> int
      :error -> str
    end
  end

  def extract_items_list(str) do
    [_,items] = String.split(str,": ")
    String.split(items, ", ")
    |>Enum.map(&get_int/1)
  end

  def extract_operation(str) do
    [_,operation] = String.split(str," = ")
    [l,op,r] = String.split(operation, " ")
    left = get_int(l)
    right = get_int(r)
    {left,right,op}
  end

  def extract_number(str) do
    String.replace(str, ~r/[^\d]/, "")
    |>get_int()
  end

  def get_old(data, old) do
    case data do
      "old" -> old
      _ -> data
    end
  end

  def calculate_worries({left,right,operation},old,worry_reduction) do
    l = get_old(left,old)
    r = get_old(right,old)
    case operation do
      "*" -> worry_reduction.(trunc(l * r))
      "+" -> worry_reduction.(trunc((l + r)))
    end
  end

  def perform_cycle(monkey_data, worry_reduction) do
    Enum.with_index(monkey_data)
    |>Enum.reduce(monkey_data, fn {{_,operation,test,test_true,test_false,count},index},acc ->
      new_list = Enum.at(acc,index)
      |>elem(0)
      acc = List.update_at(acc,index, fn _ -> {[],operation,test,test_true,test_false,count + length(new_list)} end)
      new_worries = Enum.map(new_list, fn i -> calculate_worries(operation,i,worry_reduction) end)
      true_items = Enum.filter(new_worries, fn i -> rem(i,test) == 0 end)
      false_items = Enum.filter(new_worries, fn i -> rem(i,test) != 0 end)
      acc = List.update_at(acc,test_true, fn {l,o,t,tt,tf,c} -> {l ++ true_items,o,t,tt,tf,c} end)
      List.update_at(acc,test_false, fn {l,o,t,tt,tf,c} -> {l ++ false_items,o,t,tt,tf,c} end)
    end)
  end

  def get_product(data) do
    Enum.map(data, fn {_,_,_,_,_,count} -> count end)
    |>Enum.sort(:desc)
    |>Enum.take(2)
    |>Enum.product()
  end
end

data = elem(File.read("ex11.txt"),1)
|>String.split("\r\n\r\n")
|>Enum.map(fn monkey_note ->
  [_,s_items,s_operation,s_test,s_true,s_false] = String.split(monkey_note,"\r\n")
  {
    Ex11.extract_items_list(s_items),
    Ex11.extract_operation(s_operation),
    Ex11.extract_number(s_test),
    Ex11.extract_number(s_true),
    Ex11.extract_number(s_false),
    0
  }
end)

solution1 = Enum.reduce(1..20,data,fn _,acc ->
  Ex11.perform_cycle(acc,&div(&1,3))
end)
|>Ex11.get_product()

lcm = data |> Enum.map(fn {_,_,test,_,_,_} -> test end) |> Enum.product()
solution2 = Enum.reduce(1..10000,data,fn _,acc ->
  Ex11.perform_cycle(acc,&rem(&1,lcm))
end)
|>Ex11.get_product()

IO.inspect(solution1, charlists: :as_lists)
IO.inspect(solution2, charlists: :as_lists)
