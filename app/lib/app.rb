require 'app/version'
require 'app/hand'
require 'app/card'

module App
  class Table
    def initialize(observer)
      @observer = observer

      @player = Player.new(self, observer)
      @dealer = Dealer.new(self, observer)
    end

    def player
      @player
    end

    def dealer
      @dealer
    end
  end

  class Dealer
    def initialize(table, observer)
      @table = table
      @observer = observer

      @hand = Hand.new
    end

    def use_deck(deck)
      @deck = deck
    end

    def deal
      2.times do
        deal_card(@table.player)
        deal_card(self)
      end

      @observer.dealt(dealer_card: @hand.cards[1])
      @observer.player_turn(player_hand: @table.player.hand)
    end

    def get_card(card)
      @hand.add(card)
    end

    def deal_card(player)
      player.get_card(@deck.cards.shift)
    end

    def play_turn
      @observer.dealer_reveals_hand(dealer_hand: @hand)

      while @hand.value < 17
        deal_card(self)
        @observer.dealer_hits(dealer_hand: @hand)
      end

      if @hand.value > 21
        @observer.dealer_busts
      end

      win = @table.player.hand.value <= 21 && (@table.player.hand.value > @hand.value || @hand.value > 21)
      @observer.round_over(dealer_value: @hand.value, win: win)
    end
  end

  class Player
    def initialize(table, observer)
      @table = table
      @observer = observer

      @hand = Hand.new
    end

    def get_card(card)
      @hand.add(card)
    end

    def hand
      @hand
    end

    def hit
      @table.dealer.deal_card(self)

      if @hand.value > 21
        @observer.bust(player_hand: @hand)
        @table.dealer.play_turn
      else
        @observer.player_turn(player_hand: @hand)
      end
    end

    def stay
      @table.dealer.play_turn
    end
  end

  class Deck
    def self.default
      deck = []

      for i in 2..14
        deck << Card.new(i, Card::CLUBS)
        deck << Card.new(i, Card::HEARTS)
        deck << Card.new(i, Card::SPADES)
        deck << Card.new(i, Card::DIAMONDS)
      end

      return Deck.new(deck)
    end

    def shuffle
      @cards.shuffle!
    end

    def initialize(cards)
      @cards = cards
    end

    def cards
      @cards
    end
  end
end
