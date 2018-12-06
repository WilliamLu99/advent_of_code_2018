BEGINS_SHIFT = /begins shift/
WAKE_UP = /wakes up/
FALLS_ASLEEP = /falls asleep/
ID = /(?<=#)\d+/
TIME = /\[(\d+)-(\d+)-(\d+) (\d+):(\d+)/
require 'byebug'

def main
  data = IO.readlines("data/day4.txt")
  data = sort(data)

  guards = {}
  current_guard = nil
  data.each do |log|
    time = process_time(TIME.match log)

    if BEGINS_SHIFT.match log
      if current_guard&.currently_asleep
        current_guard.wake_up time
      end

      id = (ID.match log)[0].to_i
      if guards.keys.include? id
        current_guard = guards[id]
      else
        guards[id] = Guard.new(id)
        current_guard = guards[id]
      end
    elsif WAKE_UP.match log
      current_guard&.wake_up time
    elsif FALLS_ASLEEP.match log
      current_guard&.sleep time
    end
  end

  desired_guard_id = -1
  desired_minute = -1
  desired_minute_count = -1

  guards.values.each do |guard|
    max_min = -1
    max_min_count = -1
    guard.sleep_minute_hist.each do |key, value|
      if value > max_min_count
        max_min_count = value
        max_min = key
      end 
    end

    if max_min_count > desired_minute_count
      desired_guard_id = guard.id
      desired_minute = max_min
      desired_minute_count = max_min_count
    end
  end

  puts desired_guard_id * desired_minute
end

def sort(data)
  data_hash = {}
  data.each { |log| data_hash[process_time TIME.match log] = log }
  data_hash = data_hash.sort_by {|time, log| time}.collect { |x| x[1] }
end

def process_time(time)
  Time.new(time[1], time[2], time[3], time[4], time[5])
end

class Guard
  attr_accessor :id, :currently_asleep, :sleep_minute_hist, :time_asleep, :last_sleep_time

  def initialize(id)
    @id = id
    @currently_asleep = false
    @sleep_minute_hist = Hash.new(0)
    @time_asleep = 0
    @last_sleep_time = nil
  end

  def wake_up(time)
    @time_asleep += time.to_i - @last_sleep_time.to_i if @currently_asleep
    @last_sleep_time.min.upto(time.min - 1) do |x|
      @sleep_minute_hist[x] += 1
    end
    @currently_asleep = false
  end

  def sleep(time)
    @last_sleep_time = time
    @currently_asleep = true
  end
end

main
