class Oystercard
  attr_reader :balance
  attr_reader :in_use
  attr_reader :entry_station

  LIMIT = 90
  MINIMUM_FARE = 1


  def initialize
    @balance = 0
    @entry_station = nil
  end

  def top_up(amount)
    @balance + amount > LIMIT ? limit_error : @balance += amount
  end

  def limit_error
    raise "Error: top up will exceed balance limit of £#{LIMIT}"
  end

  def in_journey?
    !!entry_station
  end

  def touch_in(station)
    raise "Insufficient balance to touch in" if @balance < MINIMUM_FARE
    @entry_station = station
  end

  def touch_out
    deduct_fare(MINIMUM_FARE)
    @entry_station = nil 
  end

  private

  def deduct_fare(amount)
    @balance -= amount
  end
end
