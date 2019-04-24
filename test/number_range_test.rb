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
      @date = Date.parse('2019-03-01')
      Timecop.freeze @date
    end

    after do
      Timecop.return
    end

    it 'parses yyyy as year with 4 digits' do
      assert_equal '2019', NumberRange.parse('yyyy').to_s
    end

    it 'parses yy as year with 2 digits' do
      assert_equal '19', NumberRange.parse('yy').to_s
    end

    it 'parses mm as month with 2 digits' do
      assert_equal '03', NumberRange.parse('mm').to_s
    end

    it 'parses dd as month with 2 digits' do
      assert_equal '01', NumberRange.parse('dd').to_s
    end

    it 'parses # as one generated digit' do
      assert_equal '1', NumberRange.parse('#').to_s
    end

    it 'parses ## as two generated digits' do
      assert_equal '01', NumberRange.parse('##').to_s
    end

    it 'parses ##### as three generated digits' do
      assert_equal '00001', NumberRange.parse('#####').to_s
    end

    it 'parses spaces and dashes as strings' do
      assert_equal ' ', NumberRange.parse(' ').to_s
      assert_equal '-', NumberRange.parse('-').to_s
    end

    it 'parses combined statements' do
      assert_equal '190301-01', NumberRange.parse('yymmdd-##').to_s
    end
  end

  describe '#next' do
  end

end
