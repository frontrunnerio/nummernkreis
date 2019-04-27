require "nummernkreis/version"
require 'date'

# Nummernkreis
#
# class to generate and increment number ranges based on a simple pattern
#
# pattern can include:
#
# yyyy::  year with 4 digit representation (e.g. 2018)
# yy::    year with 2 digit representation (e.g. 80 for 1980)
# mm::    month with 2 digits (e.g. 03 for March)
# dd::    day of the month with 2 digits (e.g. 01 for the first day)
# -::     dash separator
# #::     placeholder for variable digit part / counter (e.g. 001 as first value for ###)
#
class Nummernkreis
  class Error < StandardError; end

  # @param pattern [String] number range pattern
  def initialize pattern
    @pattern = pattern
    @number_now = PatternParser.new(pattern).sample
    @number = @number_now
  end

  # returns the current number range string
  # @return [String] current number range
  def to_s
    @number
  end

  # increments the digit part of the number range
  # @param now [Boolean] if the next number should be generated for today
  # @return [String] next number range
  def next(now: false)
    @number = if now && !numbers_equal_without_digits?(@number, @number_now)
                @number_now
              else
                increment_digits_for_number @number
              end
  end

  # "parses" the number range (sets the current number range)
  # @return [Nummernkreis] instance
  def parse number
    @number = number
    self
  end

  private

  def increment_digits_for_number number
    digit_count = @pattern.split('').count('#')
    raise Error.new('only works if pattern has a digit part') if digit_count == 0

    before_digits, digits, after_digits = decompose_number_parts(@number)
    new_digits = format("%0#{digit_count}d", digits.to_i + 1)

    "#{before_digits}#{new_digits}#{after_digits}"
  end

  def numbers_equal_without_digits? number1, number2
    parts1 = decompose_number_parts number1
    parts2 = decompose_number_parts number2
    parts1[0] == parts2[0] && parts1[2] == parts2[2]
  end

  def decompose_number_parts number
    digits_start_at = @pattern.index('#')
    digits_end_at = @pattern.rindex('#')

    [
      digits_start_at < 1 ? '' : number[0..digits_start_at-1],
      number[digits_start_at..digits_end_at],
      number[digits_end_at+1..number.length]
    ]
  end

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