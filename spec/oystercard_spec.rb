require "oystercard"

RSpec.describe Oystercard do
  FUNDS = 10
  LIMIT = 90
  let(:top_up) { subject.top_up(FUNDS) }
  it 'has an initial balance of 0' do
    expect(subject.balance).to eq(0)
  end

  it 'receives a top up amount of 5' do
    top_up
    expect(subject.balance).to eq(FUNDS)
  end

  it 'has a maximum limit of 90' do

    expect { subject.top_up(LIMIT + 1) }.to raise_error("Error: top up will exceed balance limit of £#{LIMIT}")
  end

  it 'is not in journey' do
    expect(subject).not_to be_in_journey
  end

  it 'in journey when touch in' do
    top_up
    subject.touch_in("Aldgate")
    expect(subject).to be_in_journey
  end

  it 'not in journey when touch out' do
    top_up
    subject.touch_in("Aldgate")
    subject.touch_out
    expect(subject).not_to be_in_journey
  end

  it 'raises error when balance is less than 1' do
    expect { subject.touch_in("Aldgate") }.to raise_error("Not enough money")
  end

  it "reduces balance by min fare on touch_out" do
    top_up
    subject.touch_in("Aldgate")
    expect{ subject.touch_out }.to change{ subject.balance }.by (-Oystercard::MINIMUM_FARE)
  end

  it 'records the entry station' do
    top_up
    subject.touch_in("Aldgate")
    expect(subject.entry_station).to eq("Aldgate")
  end
end
