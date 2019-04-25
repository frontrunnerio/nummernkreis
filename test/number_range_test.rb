require "test_helper"

describe NumberRange do

  before do
    Timecop.freeze Date.parse('2019-03-01')
  end

  after do
    Timecop.return
  end

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

    it 'parses dash as string' do
      assert_equal '-', NumberRange.parse('-').to_s
    end

    it 'parses combined statements' do
      assert_equal '20190001', NumberRange.parse('yyyy####').to_s
      assert_equal '190301-01', NumberRange.parse('yymmdd-##').to_s
      assert_equal '0101-2019', NumberRange.parse('dd##-yyyy').to_s
    end

    it 'cannot have more than one number part' do
      assert_raises NumberRange::Error do
        NumberRange.new('yy##dd##')
      end
    end
  end

  describe '#next' do
    it 'returns the next number in the range' do
      range = NumberRange.new('yymmdd-##')
      assert_equal '190301-01', range.to_s
      assert_equal '190301-02', range.next
      assert_equal '190301-03', range.next

      range = NumberRange.new('####-ddmmyy')
      assert_equal '0001-010319', range.to_s
      assert_equal '0002-010319', range.next
      assert_equal '0003-010319', range.next
    end
  end

end
