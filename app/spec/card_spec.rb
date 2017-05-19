require 'spec_helper'

describe App::Card do
  it 'can print the name of a card' do
    expect(App::Card.new(3, App::Card::HEARTS).to_s).to eq '3 of Hearts'
    expect(App::Card.new(10, App::Card::HEARTS).to_s).to eq '10 of Hearts'
    expect(App::Card.new(11, App::Card::CLUBS).to_s).to eq 'Jack of Clubs'
    expect(App::Card.new(12, App::Card::DIAMONDS).to_s).to eq 'Queen of Diamonds'
    expect(App::Card.new(13, App::Card::HEARTS).to_s).to eq 'King of Hearts'
    expect(App::Card.new(14, App::Card::SPADES).to_s).to eq 'Ace of Spades'
  end

  it 'can get the value of a card' do
    expect(App::Card.new(3, App::Card::HEARTS).value).to eq 3
    expect(App::Card.new(10, App::Card::HEARTS).value).to eq 10
    expect(App::Card.new(11, App::Card::CLUBS).value).to eq 10
    expect(App::Card.new(12, App::Card::DIAMONDS).value).to eq 10
    expect(App::Card.new(13, App::Card::HEARTS).value).to eq 10
    expect(App::Card.new(14, App::Card::SPADES).value).to eq 11
  end
end
