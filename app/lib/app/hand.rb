module App
  class Hand
    def initialize(cards = [])
      @cards = cards
    end

    def cards
      @cards
    end

    def add(card)
      @cards << card
    end

    def value
      value = @cards.map(&:value).reduce(:+)

      @cards.select { |card| card.name === 'Ace' }.each do
        if value > 21
          value -= 10
        end
      end

      value
    end
  end
end
