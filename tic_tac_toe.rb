require 'pry'

def tic_tac_toe_game
  board = Array.new(3) { ['_', '_', '_'] }
  winner = nil
  loop do
    display_board(board)
    row, column = get_position_from_user(board)
    board[row - 1][column - 1] = "X"

    winner = check_if_winner(board)
    break if winner == true || winner == false

    display_board(board)
    break if check_if_board_full(board)

    computer_makes_move(board)

    winner = check_if_winner(board)
    break if winner == true || winner == false
  end

  if winner == true || winner == false
    winner ? puts("You Lose.") : puts("You Win.")
  else
    puts "We tied"
  end


end

def check_if_board_full(board)
  board_full = board.all? do |row|
    row.all? do |element|
      element != '_'
    end
  end
  return board_full
end

def check_if_winner(board)
  check_row_winner = determine_row_winner(board)
  return check_row_winner if check_row_winner == true || check_row_winner == false

  check_column_winner = determine_column_winner(board, 'X')
  return false if check_column_winner == 'X'

  check_column_winner = determine_column_winner(board, 'O')
  return true if check_column_winner == 'O'

  check_diagonal_winner = determine_diagonal_winner(board, 'X')
  return false if check_diagonal_winner == 'X'

  check_diagonal_winner = determine_diagonal_winner(board, 'O')
  return true if check_diagonal_winner == 'O'

  return nil
end

def determine_diagonal_winner(board, x_or_o_string)
  if board[0][0] == board[1][1] && board[0][0] == board[2][2] && board[0][0] == x_or_o_string
    return x_or_o_string
  elsif board[2][0] == board[1][1] && board[2][0] == board[0][2] && board[2][0] == x_or_o_string
    return x_or_o_string
  else
    return nil
  end
end

def determine_column_winner(board, x_or_o_string)
  if board[0][0] == board[1][0] && board[0][0] == board[2][0] && board[0][0] == x_or_o_string
    return x_or_o_string
  elsif board[0][1] == board[1][1] && board[0][1] == board[2][1] && board[0][1] == x_or_o_string
    return x_or_o_string
  elsif board[0][2] == board[1][2] && board[0][2] == board[2][2] && board[0][2] == x_or_o_string
    return x_or_o_string
  else
    return nil
  end
end

def determine_row_winner(board)
  board.each do |sub_arr|
    if sub_arr.all? { |element| element == "X" }
      return false
    elsif sub_arr.all? { |element| element == "O" }
      return true
    end
  end
  return nil
end

def display_board(arr)
  p arr[0]
  p arr[1]
  p arr[2]
end

def get_position_from_user(arr)
  row = nil
  column = nil
  puts("Your Turn")
  loop do
    puts("Select row, and then column, where you would like to place your mark")

    loop do
      puts("Enter Row (1, 2, or 3)")
      row = gets.chomp.to_i
      break if row == 1 || row == 2 || row == 3
    end

    loop do
      puts("Enter Column (1, 2, or 3)")
      column = gets.chomp.to_i
      break if column == 1 || column == 2 || column == 3
    end

    break if arr[row - 1][column - 1] == "_"
  end
  return row, column
end

def computer_makes_move(arr)
  puts "Okay, now it is my turn."
  Kernel.sleep(0.5)

  loop do
    row =    ((0..2).to_a).sample
    column = ((0..2).to_a).sample
    if arr[row][column] == "_"
      arr[row][column] = "O"
      break
    end
  end
end

tic_tac_toe_game
