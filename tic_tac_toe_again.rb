require 'pry'

PLAYER_MARKER = "X"
COMPUTER_MARKER = "O"
INITIALIZE_MARKER = " "

def display_board(board)
  Kernel.system('clear')

  puts "     |      |     "
  puts "  #{board[1]}  |   #{board[2]}  |   #{board[3]}  "
  puts "-----+------+-------"
  puts "     |      |     "
  puts "  #{board[4]}  |   #{board[5]}  |   #{board[6]}  "
  puts "-----+------+-------"
  puts "     |      |     "
  puts "  #{board[7]}  |   #{board[8]}  |   #{board[9]}  "
  puts ""
  puts "User Move: X -- Computer Move: O"
  puts ""
end

def initialize_board
  board = {}
  (1..9).each { |num| board[num] = INITIALIZE_MARKER }
  return board
end

def available_keys(board)
  board.keys.select { |key| board[key] == INITIALIZE_MARKER }
end

def get_user_move!(board)
  user_move = nil
  loop do
    puts "Enter a move. Your options are (#{available_keys(board).join(', ')})."
    user_move = gets.chomp.to_i
    break if available_keys(board).include?(user_move)

    puts "Invalid move. Choose again."
  end
  board[user_move] = PLAYER_MARKER
end

def computer_move!(board)
  computer_move = available_keys(board).sample
  board[computer_move] = COMPUTER_MARKER
end

def someone_won?(board)
  winning_lines = [[1, 2, 3], [4, 5, 6], [7, 8, 9],
                   [1, 4, 7], [2, 5, 8], [3, 6, 9],
                   [1, 5, 9], [3, 5, 7]]

  winning_lines.each do |line|

    return "Player Won" if board[line[0]] == "X" &&
                           board[line[1]] == "X" &&
                           board[line[2]] == "X"
    return "Computer Won" if board[line[0]] == "O" &&
                             board[line[1]] == "O" &&
                             board[line[2]] == "O"
  end
  return nil
end

def board_full?(board)
  available_keys(board) == []
end

loop do

  board = initialize_board

  loop do
    display_board(board)
    get_user_move!(board)
    break if someone_won?(board) || board_full?(board)

    computer_move!(board)
    break if someone_won?(board) || board_full?(board)
  end

  display_board(board)

  if someone_won?(board)
    puts someone_won?(board)
  else
    puts "We Tied."
  end

  puts "Play again? (y for yes)"
  play_again = gets.chomp
  break unless play_again.downcase.start_with?('y')
end