require "test_helper"

describe NumberRange do

  it 'has a version number' do
    refute_nil ::NumberRange::VERSION
  end

  describe 'new' do
    it 'takes a string parameter' do
      refute_nil NumberRange.new('')
      assert_raises ArgumentError do
        NumberRange.new
      end
    end
  end

  describe 'parse' do
    before do
      Timecop.freeze Date.parse('2019-03-01')
    end

    after do
      Timecop.return
    end

    it 'parses yy as year with 2 digits' do
      assert_equal '19', NumberRange.parse('yy').to_s
    end

    it 'parses yyyy as year with 4 digits' do
      assert_equal '2019', NumberRange.parse('yyyy').to_s
    end

  end

  describe '#next' do
  end

end
