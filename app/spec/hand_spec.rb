require 'spec_helper'

describe App::Hand do
  let(:six_of_diamonds) { App::Card.new(6, App::Card::DIAMONDS) }
  let(:seven_of_hearts) { App::Card.new(7, App::Card::HEARTS) }
  let(:ace_of_spades) { App::Card.new(14, App::Card::SPADES) }
  let(:ace_of_clubs) { App::Card.new(14, App::Card::CLUBS) }
  let(:ten_of_hearts) { App::Card.new(10, App::Card::HEARTS) }
  let(:ten_of_clubs) { App::Card.new(10, App::Card::CLUBS) }

  it 'can return the cards in the hand' do
    hand = App::Hand.new
    hand.add(six_of_diamonds)
    hand.add(ace_of_spades)

    expect(hand.cards).to eq [six_of_diamonds, ace_of_spades]
  end

  it 'can return the proper value of a hand' do
    hand = App::Hand.new
    hand.add(six_of_diamonds)
    hand.add(seven_of_hearts)
    expect(hand.value).to eq 13

    hand = App::Hand.new
    hand.add(six_of_diamonds)
    hand.add(ace_of_spades)
    expect(hand.value).to eq 17

    hand = App::Hand.new
    hand.add(six_of_diamonds)
    hand.add(ace_of_spades)
    hand.add(ace_of_clubs)
    expect(hand.value).to eq 18
  end
end
