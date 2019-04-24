require "number_range/version"
require 'date'

class NumberRange
  class Error < StandardError; end

  def initialize pattern
    @pattern = pattern
    @number = PatternParser.new(pattern).sample
  end

  def to_s
    @number
  end

  def next

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
      while pattern.length > 0
        token = pattern.slice!(0)
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
          process_current_state unless @state.include? :number
          @state << :number
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
      when :number
        raise Error.new('can only have one number part') if @number_parsed
        @buffer << format("%0#{@state.length}d", 1)
        @number_parsed = true
      when :dash
        @buffer << '-'
      end

      @state.clear
    end
  end

end

