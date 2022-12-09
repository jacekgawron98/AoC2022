defmodule Ex9 do
  def make_move({hx,hy},{tx,ty}) do
    {dx,dy} = {hx-tx,hy-ty}
    sign_x = if hx > tx, do: 1, else: -1
    sign_y = if hy > ty, do: 1, else: -1
    {ntx,nty} = cond do
      abs(dx) > 1 and abs(dy) > 1 -> {hx-sign_x, hy-sign_y}
      abs(dx) > 1 -> {hx-sign_x, hy}
      abs(dy) > 1 -> {hx, hy-sign_y}
      true -> {tx,ty}
    end
    {ntx,nty}
  end
end

start_data = [{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0}]

{_,_,t0_all,t8_all} = File.stream!("ex9.txt")
|>Enum.map(&String.trim/1)
|>Enum.map(&String.split/1)
|>Enum.map(fn [move,count] ->
  {val, _} = Integer.parse(count)
  {move,val}
end)
|>Enum.reduce({{0,0},start_data,[{0,0}],[{0,0}]}, fn {move,count}, {{hx,hy},tails,short,long} ->
  {x,y} = case move do
    "R" -> {1,0}
    "L" -> {-1,0}
    "U" -> {0,1}
    "D" -> {0,-1}
  end
  {_, all_t, ts, tl} = Enum.reduce(1..count,{{hx,hy},tails,[],[]}, fn _, {{x1,y1},a,s,l} ->
    {nhx,nhy} = {x1+x,y1+y}
    a = List.update_at(a,0,&(Ex9.make_move({nhx,nhy},&1)))
    r = Enum.reduce(1..8,a, fn i,acc ->
      acc = List.update_at(acc,i,&(Ex9.make_move(Enum.at(acc,i-1),&1)))
      acc
    end)
    t0 = Enum.at(a,0)
    t8 = Enum.at(a,8)
    {{nhx,nhy},r, s ++ [t0], l ++ [t8] }
  end)
  {{hx + x*count,hy + y*count},all_t,short ++ ts, long ++ tl}
end)

res1 = Enum.uniq(t0_all)
|>length()

res2 = Enum.uniq(t8_all)
|>length()

IO.inspect(res1)
IO.inspect(res2)
