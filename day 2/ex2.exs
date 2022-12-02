defmodule Ex2 do
  def convert_to_move(move) do
    case move do
      m when m in ["A","X"] -> 1
      m when m in ["B","Y"] -> 2
      m when m in ["C","Z"] -> 3
    end
  end

  def convert_to_player_move(enemy,outcome) do
    case rem(convert_to_move(enemy) + 1 * outcome,3) do
      0 -> 3
      n -> n
    end
  end
end

score1 = File.stream!("ex2.txt")
|>Enum.map(&String.trim/1)
|>Enum.map(fn line ->
  [enemy,player] = String.split(line, " ")
  outcome = Ex2.convert_to_move(enemy) - Ex2.convert_to_move(player)
  case outcome do
    0 -> 3 + Ex2.convert_to_move(player)
    n when n in [1,-2] -> 0 + Ex2.convert_to_move(player)
    n when n in [-1,2] -> 6 + Ex2.convert_to_move(player)
  end
end)
|>Enum.sum()

score2 = File.stream!("ex2.txt")
|>Enum.map(&String.trim/1)
|>Enum.map(fn line ->
  [enemy,outcome] = String.split(line, " ")
  case outcome do
    "X" -> 0 + Ex2.convert_to_player_move(enemy,-1)
    "Y" -> 3 + Ex2.convert_to_move(enemy)
    "Z" -> 6 + Ex2.convert_to_player_move(enemy,1)
  end
end)
|>Enum.sum()
IO.inspect(score1)
IO.inspect(score2)
