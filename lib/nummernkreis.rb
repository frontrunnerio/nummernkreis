require "nummernkreis/version"
require 'date'

class Nummernkreis
  class Error < StandardError; end

  def initialize pattern
    @pattern = pattern
    @number = PatternParser.new(pattern).sample
  end

  def to_s
    @number
  end

  def next
    digit_count = @pattern.split('').count('#')
    raise Error.new('only works if pattern has a digit part') if digit_count == 0

    digits_start_at = @pattern.index('#')
    digits_end_at = @pattern.rindex('#')

    before_digits = digits_start_at < 1 ? '' : @number[0..digits_start_at-1]
    digits = @number[digits_start_at..digits_end_at]
    after_digits = @number[digits_end_at+1..@number.length]

    new_digits = format("%0#{digit_count}d", digits.to_i + 1)

    @number = "#{before_digits}#{new_digits}#{after_digits}"
  end

  def self.parse pattern
    self.new pattern
  end

  private

  class PatternParser

    def initialize pattern
      @state = []
      @buffer = []
      @number_parsed = false
      parse pattern
    end

    def sample
      @buffer.join
    end

    def parse pattern
      pattern_copy = pattern.dup

      while pattern_copy.length > 0
        token = pattern_copy.slice!(0)
        case token
        when 'y'
          process_current_state unless @state.include? :year
          @state << :year
        when 'm'
          process_current_state unless @state.include? :month
          @state << :month
        when 'd'
          process_current_state unless @state.include? :day
          @state << :day
        when '#'
          process_current_state unless @state.include? :digit
          @state << :digit
        when '-'
          process_current_state
          @state << :dash
        else
          raise Error.new "token not recognized: #{token}"
        end
      end
      process_current_state
    end

    def process_current_state
      raise Error.new 'error in parser' if @state.uniq.length > 1

      case @state.first
      when :year
        case @state.length
        when 2
          @buffer << Date.today.strftime('%y')
        when 4
          @buffer << Date.today.strftime('%Y')
        else
          raise Error.new 'year has 2 or 4 characters'
        end
      when :month
        raise Error.new 'month has two characters' if @state.length != 2
        @buffer << Date.today.strftime('%m')
      when :day
        raise Error.new 'day has two characters' if @state.length != 2
        @buffer << Date.today.strftime('%d')
      when :digit
        raise Error.new('can only have one digit part') if @number_parsed
        @buffer << format("%0#{@state.length}d", 1)
        @number_parsed = true
      when :dash
        @buffer << '-'
      end

      @state.clear
    end
  end

end

