require "oystercard"

RSpec.describe Oystercard do
  FUNDS = 10
  LIMIT = 90

  let(:entry_station) { double :station }
  let(:exit_station) { double :station }
  let(:top_up) { subject.top_up(FUNDS) }
  let(:touch_in) { subject.touch_in(entry_station) }
  let(:touch_out) {subject.touch_out(exit_station) }
  let(:journey) { { entry_station: entry_station, exit_station: exit_station } }


  context 'on instantiation' do
    it 'has an initial balance of 0' do
      expect(subject.balance).to eq(0)
    end

    it 'is not in journey' do
      expect(subject).not_to be_in_journey
    end

    it 'has an empty list of journeys by default' do
      expect(subject.journeys).to be_empty
    end

  end

  it 'receives a top up amount' do
    top_up

    expect(subject.balance).to eq(FUNDS)
  end

  it 'has a maximum limit' do
    expect { subject.top_up(LIMIT + 1) }.to raise_error("Error: top up will exceed balance limit of £#{LIMIT}")
  end

  it 'in journey when touch in' do
    top_up

    touch_in

    expect(subject).to be_in_journey
  end

  it 'not in journey when touch out' do
    top_up
    touch_in

    touch_out

    expect(subject).not_to be_in_journey
  end

  context 'has a balance of less than 1' do
    it 'raises error on touch in' do
      expect { touch_in }.to raise_error("Insufficient balance to touch in")
    end
  end

  it 'reduces balance by min fare on touch_out' do
    top_up
    touch_in

    expect{ touch_out }.to change{ subject.balance }.by (-Oystercard::MINIMUM_FARE)
  end

  it 'records the entry station' do
    top_up

    touch_in

    expect(subject.journeys).to eq([{ start: entry_station, end: :incomplete }])
  end

  it 'can check the journey history' do
    top_up
    touch_in
    touch_out

    expect(subject.journeys).to eq([{ start: entry_station, end: exit_station }])
  end

end
