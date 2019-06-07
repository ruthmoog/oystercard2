class Oystercard
  attr_reader :balance, :in_use, :journeys

  LIMIT = 90
  MINIMUM_FARE = 1


  def initialize
    @balance = 0
    @in_use = false
    @journeys = []
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

  def touch_in(entry_station)
    if @balance < MINIMUM_FARE
      raise "Insufficient balance to touch in"
    end
    @in_use = true
    @journeys << { start: entry_station, end: nil }
  end

  def touch_out(exit_station)
    deduct_fare(MINIMUM_FARE)
    @in_use = false
    @journeys[0][:end] = exit_station
  end

  private

  def deduct_fare(amount)
    @balance -= amount
  end
end
