def convert_to_move(code)
    if (code == 'A' || code == 'X') then return 1;
    elsif (code == 'B' || code == 'Y') then return 2;
    elsif (code == 'C' || code == 'Z') then return 3;
    end
end

def convert_to_player_move(move, outcome)
    player_move = (move + 1 * outcome) % 3;  
    return player_move == 0 ? player_move + 3 : player_move;
end

def calc_score(enemy,player)
    enemy_move = convert_to_move(enemy);
    player_move = convert_to_move(player);
    result = enemy_move - player_move;
    if (result == 0) then return 3 + player_move;
    elsif (result == 1 || result == -2) then return 0 + player_move;
    elsif (result == -1 || result == 2) then return 6 + player_move;
    end    
end

def calc_score2(enemy,outcome)
    enemy_move = convert_to_move(enemy);
    if (outcome == 'X') then return 0 + convert_to_player_move(enemy_move, -1) 
    elsif (outcome == 'Y') then return 3 + enemy_move 
    elsif (outcome == 'Z') then return 6 + convert_to_player_move(enemy_move, 1)
    end 
end

score1 = 0;
score2 = 0;
File.foreach("ex2.txt") { |line| 
    line.chomp!;
    data = line.split(' ');
    score1 += calc_score(data[0],data[1]);
    score2 += calc_score2(data[0],data[1]);
}
puts(score1);
puts(score2);