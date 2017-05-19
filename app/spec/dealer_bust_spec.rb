require "spec_helper"

RSpec.describe App do
  let(:observer) { spy(:observer) }
  let(:table) { App::Table.new(observer) }
  let(:dealer) { table.dealer }
  let(:player) { table.player }

  let(:nine_of_clubs) { App::Card.new(9, App::Card::CLUBS) }
  let(:ten_of_hearts) { App::Card.new(10, App::Card::HEARTS) }
  let(:eight_of_spades) { App::Card.new(8, App::Card::SPADES) }
  let(:six_of_clubs) { App::Card.new(6, App::Card::CLUBS) }
  let(:ten_of_spades) { App::Card.new(10, App::Card::SPADES) }

  let(:deck) { App::Deck.new([
    nine_of_clubs,
    ten_of_hearts,
    eight_of_spades,
    six_of_clubs,
    ten_of_spades
  ]) }

  before do
    allow(observer).to receive(:player_turn) do |args|
      @player_cards = args[:player_hand].cards
    end

    allow(observer).to receive(:dealer_hits) do |args|
      @dealer_hand = args[:dealer_hand].cards
    end

    dealer.use_deck(deck)
    dealer.deal
  end

  it 'notifies the observer that it is the players turn' do
    expect(observer).to have_received(:dealt).with(dealer_card: six_of_clubs)
    expect(@player_cards).to eq [nine_of_clubs, eight_of_spades]
  end

  context 'when the player stays' do
    before do
      player.stay
    end

    it 'is a win when the dealer busts' do
      expect(@dealer_hand).to eq [ten_of_hearts, six_of_clubs, ten_of_spades]
      expect(observer).to have_received(:round_over).with(dealer_value: 26, win: true)
    end
  end
end
