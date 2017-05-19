require "spec_helper"

RSpec.describe App do
  let(:observer) { spy(:observer) }
  let(:table) { App::Table.new(observer) }
  let(:dealer) { table.dealer }
  let(:player) { table.player }

  let(:five_of_clubs) { App::Card.new(5, App::Card::CLUBS) }
  let(:seven_of_hearts) { App::Card.new(7, App::Card::HEARTS) }
  let(:ten_of_spades) { App::Card.new(10, App::Card::SPADES) }
  let(:three_of_diamonds) { App::Card.new(3, App::Card::DIAMONDS) }
  let(:ten_of_hearts) { App::Card.new(10, App::Card::HEARTS) }
  let(:six_of_clubs) { App::Card.new(6, App::Card::CLUBS) }
  let(:eight_of_spades) { App::Card.new(8, App::Card::SPADES) }

  let(:deck) { App::Deck.new([
    five_of_clubs,
    seven_of_hearts,
    ten_of_spades,
    three_of_diamonds,
    ten_of_hearts,
    six_of_clubs,
    eight_of_spades
  ]) }

  before do
    allow(observer).to receive(:player_turn) do |args|
      @player_cards = args[:player_hand].cards
    end

    allow(observer).to receive(:bust) do |args|
      @player_bust_cards = args[:player_hand].cards
    end

    allow(observer).to receive(:dealer_hits) do |args|
      @dealer_hand = args[:dealer_hand].cards
    end

    dealer.use_deck(deck)
    dealer.deal
  end

  it 'notifies the observer that it is the players turn' do
    expect(@player_cards).to eq [five_of_clubs, ten_of_spades]
  end

  context 'when the player hits' do
    before do
      player.hit
    end

    it 'notifies the observer that the player has busted' do
      expect(@player_bust_cards).to eq [five_of_clubs, ten_of_spades, ten_of_hearts]
      expect(observer).to have_received(:player_turn).once

      expect(@dealer_hand).to eq [seven_of_hearts, three_of_diamonds, six_of_clubs, eight_of_spades]
      expect(observer).to have_received(:dealer_busts)
      expect(observer).to have_received(:round_over).with(dealer_value: 24, win: false)
    end
  end
end
