require 'pry'

PLAY_TO_THESE_POINTS = 21
DEALER_HITS_TO = 17

CARD_VALUES = {
  '2' => 2, '3' => 3, '4' => 4, '5' => 5, '6' => 6, '7' => 7,
  '8' => 8, '9' => 9, '10' => 10, 'Jack' => 10, 'Queen' => 10,
  'King' => 10, 'Ace' => 11
}

def initialize_deck
  array_of_cards = []
  4.times do
    array_of_cards += ('2'..'10').to_a + ['Jack', 'Queen', 'King', 'Ace']
  end
  return array_of_cards
end

def initalize_hands!(deck)
  dealer_cards = []
  user_cards = []
  2.times do
    dealer_cards << get_card!(deck)
    user_cards << get_card!(deck)
  end

  return dealer_cards, user_cards
end

def get_card!(deck)
  deck.slice!(rand(deck.size))
end

# rubocop:disable Metrics/MethodLength
def display_cards(dealer_cards, user_cards, user_points, dealer_points=0, show_dealer_hand=false)
  Kernel.system('clear')
  string_of_user_cards = ""
  user_cards.each do |card|
    string_of_user_cards += "You have a #{card}. "
  end
  puts "#{string_of_user_cards}"
  puts "You have #{user_points} points.\n\n"
  if show_dealer_hand
    string_of_dealer_cards = ""
    dealer_cards.each do |card|
      string_of_dealer_cards += "The dealer had a #{card}."
    end
    puts "#{string_of_dealer_cards}"
    puts "The dealer had #{dealer_points} points.\n\n"
  else
    puts "The dealer has a #{dealer_cards[0]} and a hidden card.\n\n"
  end
end
# rubocop:enable Metrics/MethodLength

def get_points(cards)
  total_points = cards.reduce(0) { |sum, card| sum + CARD_VALUES[card] }
  cards.each do |card|
    if card == 'Ace' && total_points > PLAY_TO_THESE_POINTS
      total_points -= 10
    end
  end
  return total_points
end

def hit_or_stay
  loop do
    puts "Would you like to hit or stay?\n\n"
    user_input = gets.chomp.downcase
    return user_input if user_input == 'stay' || user_input == 'hit'
    puts "Invalid option."
  end
end

def get_dealer_final_hand(dealer_cards, deck, dealer_points)
  loop do
    break if dealer_points >= DEALER_HITS_TO
    dealer_cards << get_card!(deck)
    dealer_points = get_points(dealer_cards)
  end
  return dealer_points
end

user_wins = 0
dealer_wins = 0

loop do
  deck = initialize_deck
  dealer_cards, user_cards = initalize_hands!(deck)
  user_points = nil


  loop do
    user_points = get_points(user_cards)
    display_cards(dealer_cards, user_cards, user_points)
    break if user_points >= PLAY_TO_THESE_POINTS

    user_input = hit_or_stay
    break if user_input == 'stay'

    user_cards << get_card!(deck)
  end

  dealer_points = get_points(dealer_cards)
  dealer_points = get_dealer_final_hand(dealer_cards, deck, dealer_points)

  display_cards(dealer_cards, user_cards, user_points, dealer_points, show_dealer_points=true)

  if (user_points > PLAY_TO_THESE_POINTS && dealer_points > PLAY_TO_THESE_POINTS) ||
      user_points == dealer_points
    puts "You tied."
  elsif user_points > PLAY_TO_THESE_POINTS ||
    (user_points < dealer_points && dealer_points <= PLAY_TO_THESE_POINTS)
    puts "You lose."
    dealer_wins += 1
  else
    puts "You win."
    user_wins += 1
  end

  puts "Your wins: #{user_wins}. Dealer wins: #{dealer_wins}."
  break if user_wins == 5 || dealer_wins == 5
  puts "\nPlay Again? (y or n)\n\n"
  play_again = gets.chomp.downcase
  break unless play_again == 'y'
end
