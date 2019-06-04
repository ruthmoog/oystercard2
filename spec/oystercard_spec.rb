require "oystercard"

RSpec.describe Oystercard do
  it 'has an initial balance of 0' do
    expect(subject.balance).to eq(0)
  end

  it 'receives a top up amount of 5' do
    subject.top_up(5)

    expect(subject.balance).to eq(5)
  end

  it 'has a maximum limit of 90' do
    LIMIT = 90
    expect { subject.top_up(100) }.to raise_error("Error: top up will exceed balance limit of £#{LIMIT}")
  end

  it 'deducts a fare amount of 3' do
    expect{ subject.deduct_fare 3 }.to change{ subject.balance }.by -3
  end
end
