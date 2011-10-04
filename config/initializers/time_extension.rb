class Time
  class << self
    def next(day, from = nil)
      target_day = [:sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday].find_index(day) if day.class == Symbol
      one_day = 60 * 60 * 24
      original_date = from || now
      result = original_date
      result += one_day until result > original_date && result.wday == target_day
      result
    end
  end
end
