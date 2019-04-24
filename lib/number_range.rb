require "number_range/version"
require 'date'

class NumberRange
  class Error < StandardError; end

  def initialize pattern
    @parser = PatternParser.new pattern
  end

  def to_s
    @parser.sample
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
        when ' '
          process_current_state
          @state << :space
        when '-'
          process_current_state
          @state << :dash
        else
          throw Error
        end
      end
      process_current_state
    end

    def process_current_state
      throw Error if @state.uniq.length > 1

      case @state.first
      when :year
        case @state.length
        when 2
          @buffer << Date.today.strftime('%y')
        when 4
          @buffer << Date.today.strftime('%Y')
        else
          throw Error
        end
      when :month
        throw Error if @state.length != 2
        @buffer << Date.today.strftime('%m')
      when :day
        throw Error if @state.length != 2
        @buffer << Date.today.strftime('%d')
      when :number
        @buffer << format("%0#{@state.length}d", 1)
      when :space
        @buffer << ' '
      when :dash
        @buffer << '-'
      end

      @state.clear
    end
  end

end

