class Oystercard
  attr_reader :balance
  attr_reader :in_use
  attr_reader :entry_station

  LIMIT = 90
  MINIMUM_FARE = 1


  def initialize
    @balance = 0
    @in_use = false
    @entry_station = nil
  end

  def top_up(amount)
    @balance + amount > LIMIT ? limit_error : @balance += amount
  end

  def limit_error
    raise "Error: top up will exceed balance limit of £#{LIMIT}"
  end

  def in_journey?
    @in_use
  end

  def touch_in(station)
    if @balance < MINIMUM_FARE
      raise "Not enough money"
    end
    @entry_station = station
    @in_use = true
  end

  def touch_out
    deduct_fare(MINIMUM_FARE)
    @in_use = false
  end

  private

  def deduct_fare(amount)
    @balance -= amount
  end
end
