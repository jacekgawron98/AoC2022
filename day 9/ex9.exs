defmodule Ex9 do
  def calculate_tail_position(hx,hy,tx,ty,0,_,_) do
    {hx,hy,tx,ty,[]}
  end

  def move_many(moves,move) do
    {x,y} = case move do
      "R" -> {1,0}
      "L" -> {-1,0}
      "U" -> {0,1}
      "D" -> {0,-1}
    end
    Enum.reduce(move, )
  end

  def calculate_tail_position(hx,hy,tx,ty,count,move,len \\ 1) do
    {x,y} = case move do
      "R" -> {1,0}
      "L" -> {-1,0}
      "U" -> {0,1}
      "D" -> {0,-1}
    end
    {ntx,nty} = cond do
      abs(hx+x - tx) > len and hy+y != ty -> {tx+x, hy+y}
      abs(hy+y - ty) > len and hx+x != tx -> {hx+x, ty+y}
      abs(hx+x - tx) > len -> {tx+x, ty}
      abs(hy+y - ty) > len -> {tx, ty+y}
      true -> {tx,ty}
    end
    IO.inspect(hx+x)
    IO.inspect(hy+y)
    IO.inspect(ntx)
    IO.inspect(nty)
    IO.inspect("=======")
    {nhx,nhy,nx,ny,moves} = calculate_tail_position(hx+x,hy+y,ntx,nty,count-1,move,len)
    {nhx,nhy,nx,ny,[{nty,ntx}] ++ moves}
  end
end
data = File.stream!("ex9t.txt")
|>Enum.map(&String.trim/1)
|>Enum.map(&String.split/1)
|>Enum.map(fn [move,count] ->
  {val, _} = Integer.parse(count)
  {move,val}
end)

#res = Enum.reduce(data, {0,0,0,0,[{0,0}]}, fn {move,count},{hx,hy,tx,ty,visited} ->
#  {nhx,nhy,nx,ny,moves} = Ex9.calculate_tail_position(hx,hy,tx,ty,count,move)
#  {nhx,nhy,nx,ny,visited ++ moves}
#end)
#|>elem(4)
#|>Enum.uniq()
#|>length()
res2 = [{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0}]
|>Enum.with_index()
|>Enum.reduce_while()
res2 = Enum.reduce(data, {0,0,0,0,[{0,0}]}, fn {move,count},{hx,hy,tx,ty,visited} ->
  {nhx,nhy,nx,ny,moves} = Ex9.calculate_tail_position(hx,hy,tx,ty,count,move,10)
  {nhx,nhy,nx,ny,visited ++ moves}
end)
|>elem(4)
#|>Enum.uniq()
#|>length()

#IO.inspect(res)
IO.inspect(res2)
