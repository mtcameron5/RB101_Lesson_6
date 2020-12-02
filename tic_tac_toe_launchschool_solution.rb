# 1.  Display the initial empty 3x3 board.
# 2.  Ask the user to mark a square.
# 3.  Computer marks a square.
# 4.  Display the updated board state.
# 5.  If winner, display winner.
# 6.  If board is full, display tie
# 7.  If neither winner nor board is full, go to #2
# 8.  Play Again?
# 9.  If yes, go to #1
# 10. Goodbye!

require 'pry'

INITIAL_MARKER = ' '
PLAYER_MARKER = 'X'
COMPUTER_MARKER = 'O'
WHO_GOES_FIRST = 'Computer'

WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] +
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] +
                [[1, 5, 9], [3, 5, 7]]

def prompt(msg)
  puts "==> #{msg}"
end

# rubocop:disable Metrics/AbcSize
def display_board(brd, player_wins, computer_wins)
  system 'clear'
  puts ""
  puts "Player Wins: #{player_wins}. Computer Wins: #{computer_wins}"
  puts "You're a #{PLAYER_MARKER}. Computer is a #{COMPUTER_MARKER}."
  puts ""
  puts "     |     |    "
  puts "  #{brd[1]}  |  #{brd[2]}  |  #{brd[3]}   "
  puts "     |     |    "
  puts "-----+-----+-----"
  puts "     |     |    "
  puts "  #{brd[4]}  |  #{brd[5]}  |  #{brd[6]}   "
  puts "     |     |    "
  puts "-----+-----+-----"
  puts "     |     |    "
  puts "  #{brd[7]}  |  #{brd[8]}  |  #{brd[9]}   "
  puts "     |     |    "
  puts ""
end
# rubocop:enable Metrics/AbcSize

def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }
  return new_board
end

def empty_squares(brd)
  brd.keys.select { |num| brd[num] == INITIAL_MARKER }
end

def joinor(arr, last_word="or")
  new_arr = arr.map.with_index do |element, index|
    if index == arr.count - 1
      "#{last_word} #{element}"
    else
      "#{element}, "
    end
  end
  new_arr.join('')
end

def player_places_piece!(brd)
  square = ''
  loop do
    prompt("Choose a square (#{joinor(empty_squares(brd))}): ")
    square = gets.chomp.to_i
    break if empty_squares(brd).include?(square)
    prompt("Sorry, that's not a valid choice.")
  end

  brd[square] = PLAYER_MARKER
end

def computer_places_piece!(brd)
  winning_move = find_at_risk_square(brd, COMPUTER_MARKER)
  saving_move = find_at_risk_square(brd, PLAYER_MARKER)
  if winning_move
    brd[winning_move] = COMPUTER_MARKER
  elsif saving_move
    brd[saving_move] = COMPUTER_MARKER
  elsif brd[5] == " "
    brd[5] = COMPUTER_MARKER
  else
    square = empty_squares(brd).sample
    brd[square] = COMPUTER_MARKER
  end
end

def board_full?(brd)
  empty_squares(brd).empty?
end

def someone_won?(brd)
  !!detect_winner(brd)
end

def place_piece!(board, current_player)
  current_player == 'User' ? player_places_piece!(board) : computer_places_piece!(board)
end

def alternate_player(current_player)
  next_move = nil
  current_player == 'User' ? next_move = 'Computer' : next_move = 'User'
  return next_move
end

def find_at_risk_square(brd, marker)
  empty_square = nil
  WINNING_LINES.each do |line|
    if brd.values_at(line[0], line[1], line[2]).count(marker) == 2
      empty_square = [line[0], line[1], line[2]].select { |value| brd[value] == INITIAL_MARKER }
    end
  end

  if empty_square == [] || empty_square == nil
    return nil
  else
    return empty_square[0]
  end

end

def detect_winner(brd)
  WINNING_LINES.each do |line|
    if brd.values_at(line[0], line[1], line[2]).count(PLAYER_MARKER) == 3
      return 'Player'
    elsif brd.values_at(line[0], line[1], line[2]).count(COMPUTER_MARKER) == 3
      return 'Computer'
    end
  end
  return nil
end

player_wins = 0
computer_wins = 0
loop do
  board = initialize_board
  current_player = WHO_GOES_FIRST

  loop do
    display_board(board, player_wins, computer_wins)
    place_piece!(board, current_player)
    current_player = alternate_player(current_player)
    break if someone_won?(board) || board_full?(board)
  end

  display_board(board, player_wins, computer_wins)
  if someone_won?(board)
    prompt("#{detect_winner(board)} won!")
    if(detect_winner(board) == 'Player')
      player_wins += 1
    else
      computer_wins += 1
    end
  else
    prompt("It's a tie!")
  end

  prompt("Play again? (y or n)")
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end

prompt("Thanks for playing Tic Tac Toe! Good bye!")
