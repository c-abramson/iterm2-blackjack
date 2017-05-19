require "spec_helper"

RSpec.describe App do
  let(:observer) { spy(:observer) }
  let(:table) { App::Table.new(observer) }
  let(:dealer) { table.dealer }
  let(:player) { table.player }

  let(:six_of_clubs) { App::Card.new(6, App::Card::CLUBS) }
  let(:seven_of_hearts) { App::Card.new(7, App::Card::HEARTS) }
  let(:four_of_spades) { App::Card.new(4, App::Card::SPADES) }
  let(:three_of_diamonds) { App::Card.new(3, App::Card::DIAMONDS) }
  let(:jack_of_hearts) { App::Card.new(11, App::Card::HEARTS) }
  let(:nine_of_clubs) { App::Card.new(9, App::Card::CLUBS) }

  let(:deck) { App::Deck.new([
    six_of_clubs,
    seven_of_hearts,
    four_of_spades,
    three_of_diamonds,
    jack_of_hearts,
    nine_of_clubs
  ]) }

  before do
    allow(observer).to receive(:player_turn) do |args|
      @player_cards = args[:player_hand].cards
    end

    allow(observer).to receive(:dealer_reveals_hand) do |args|
      @dealer_revealed_hand = args[:dealer_hand].cards.clone
    end

    allow(observer).to receive(:dealer_hits) do |args|
      @dealer_hand = args[:dealer_hand].cards
    end

    dealer.use_deck(deck)
    dealer.deal
  end

  it 'notifies the observer that it is the players turn' do
    expect(observer).to have_received(:dealt).with(dealer_card: three_of_diamonds)
    expect(@player_cards).to eq [six_of_clubs, four_of_spades]
  end

  context 'when the player hits' do
    before do
      player.hit
    end

    it 'notifies the observer that it is the players turn' do
      expect(@player_cards).to eq [six_of_clubs, four_of_spades, jack_of_hearts]
    end

    context 'when the player stays' do
      before do
        player.stay
      end

      it 'is the dealers turn' do
        expect(@dealer_revealed_hand).to eq [seven_of_hearts, three_of_diamonds]
        expect(@dealer_hand).to eq [seven_of_hearts, three_of_diamonds, nine_of_clubs]
      end

      it 'notifies the observer that the round is over with the result' do
        expect(observer).to have_received(:round_over).with(dealer_value: 19, win: true)
      end
    end
  end
end
