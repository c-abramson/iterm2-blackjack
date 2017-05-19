module App
  class Card
    HEARTS = :hearts
    SPADES = :spades
    CLUBS = :clubs
    DIAMONDS = :diamonds

    def initialize(value, suit)
      @value = value
      @suit = suit
    end

    def name
      case @value
        when 11
          'Jack'
        when 12
          'Queen'
        when 13
          'King'
        when 14
          'Ace'
        else
          @value
      end
    end

    def value
      if @value == 14
        11
      elsif @value > 10
        10
      else
        @value
      end
    end

    def suit
      @suit
    end

    def to_s
      "#{name} of #{@suit.capitalize}"
    end
  end
end
