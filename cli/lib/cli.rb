require "app"
require "rmagick"

module Cli
  def self.run
    Game.new
  end

  class Game
    def initialize
      table = App::Table.new(self)

      deck = App::Deck.default
      deck.shuffle

      @player = table.player

      dealer = table.dealer
      dealer.use_deck(deck)
      dealer.deal
    end

    def dealt(dealer_card:)
      puts "The dealer is showing #{dealer_card}"

      save_hidden_dealer_hand(dealer_card)
    end

    def player_turn(player_hand:)
      save_player_hand(player_hand)
      print_game

      puts "Your hand: #{player_hand.cards.join(', ')}"
      puts "The value of your hand is #{player_hand.value}"
      puts 'It is your turn. Hit or stay? (h, s)'
      get_player_input
    end

    def dealer_reveals_hand(dealer_hand:)
      puts "The dealer reveals a #{dealer_hand.cards.first}"

      save_dealer_hand(dealer_hand)
      print_game
    end

    def dealer_hits(dealer_hand:)
      puts "The dealer hits with a #{dealer_hand.cards.last}"

      save_dealer_hand(dealer_hand)
      print_game
    end

    def dealer_busts
      puts "The dealer busted!"
    end

    def bust(player_hand:)
      save_player_hand(player_hand)
      print_game

      puts "Your hand: #{player_hand.cards.join(', ')}"
      puts "The value of your hand is #{player_hand.value}"
      puts "You busted!"
    end

    def round_over(dealer_value:, win:)
      puts "The round is over. The dealer has #{dealer_value}. It is #{win} that you won."
    end

    def get_player_input
      if gets.chomp === 'h'
        @player.hit
      else
        @player.stay
      end
    end

    private

    def save_player_hand(player_hand)
      image = Magick::ImageList.new

      player_hand.cards.each do |card|
        image.push(Magick::Image.read(File.expand_path("#{File.dirname(__FILE__)}/../assets/#{card.name.to_s.downcase}_of_#{card.suit.downcase}.png")).first)
      end

      File.delete('player_hand.png') if File.exist?('player_hand.png')
      image.append(false).write('player_hand.png')
    end

    def print_game
      puts `imgcat dealer_hand.png`
      puts `imgcat player_hand.png`
    end

    def save_hidden_dealer_hand(dealer_card)
      image = Magick::ImageList.new

      image.push(Magick::Image.read(File.expand_path("#{File.dirname(__FILE__)}/../assets/back.png")).first)
      image.push(Magick::Image.read(File.expand_path("#{File.dirname(__FILE__)}/../assets/#{dealer_card.name.to_s.downcase}_of_#{dealer_card.suit.downcase}.png")).first)

      File.delete('dealer_hand.png') if File.exist?('dealer_hand.png')
      image.append(false).write('dealer_hand.png')
    end

    def save_dealer_hand(dealer_hand)
      image = Magick::ImageList.new

      dealer_hand.cards.each do |card|
        image.push(Magick::Image.read(File.expand_path("#{File.dirname(__FILE__)}/../assets/#{card.name.to_s.downcase}_of_#{card.suit.downcase}.png")).first)
      end

      File.delete('dealer_hand.png') if File.exist?('dealer_hand.png')
      image.append(false).write('dealer_hand.png')
    end
  end
end

Cli.run
