require "oystercard"

RSpec.describe Oystercard do
  FUNDS = 10
  LIMIT = 90
  it 'has an initial balance of 0' do
    expect(subject.balance).to eq(0)
  end

  it 'receives a top up amount of 5' do
    subject.top_up(FUNDS)

    expect(subject.balance).to eq(FUNDS)
  end

  it 'has a maximum limit of 90' do

    expect { subject.top_up(LIMIT + 1) }.to raise_error("Error: top up will exceed balance limit of £#{LIMIT}")
  end

  it 'deducts a fare amount of 3' do
    expect{ subject.deduct_fare 3 }.to change{ subject.balance }.by -3
  end

  it 'is not in journey' do
    expect(subject).not_to be_in_journey
  end

  it 'in journey when touch in' do
    subject.top_up(FUNDS)
    subject.touch_in
    expect(subject).to be_in_journey
  end

  it 'not in journey when touch out' do
    subject.top_up(FUNDS)
    subject.touch_in
    subject.touch_out
    expect(subject).not_to be_in_journey
  end

  it 'raises error when balance is less than 1' do
    expect { subject.touch_in }.to raise_error("Not enough money")
  end
end
