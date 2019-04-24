require "number_range/version"
require 'date'

class NumberRange
  class Error < StandardError; end

  def initialize pattern
    case pattern
    when 'yy'
      @buffer = Date.today.strftime('%y')
    when 'yyyy'
      @buffer = Date.today.strftime('%Y')
    end
  end

  def to_s
    @buffer
  end

  def next
  end

  def self.parse pattern
    self.new pattern
  end
end
