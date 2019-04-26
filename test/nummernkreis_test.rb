require "test_helper"

describe Nummernkreis do

  before do
    Timecop.freeze Date.parse('2019-03-01')
  end

  after do
    Timecop.return
  end

  it 'has a version number' do
    refute_nil ::Nummernkreis::VERSION
  end

  describe 'new' do

    it 'takes a string parameter' do
      refute_nil Nummernkreis.new('')
      assert_raises ArgumentError do
        Nummernkreis.new
      end
    end

    it 'parses yyyy as year with 4 digits' do
      assert_equal '2019', Nummernkreis.new('yyyy').to_s
    end

    it 'parses yy as year with 2 digits' do
      assert_equal '19', Nummernkreis.new('yy').to_s
    end

    it 'parses mm as month with 2 digits' do
      assert_equal '03', Nummernkreis.new('mm').to_s
    end

    it 'parses dd as month with 2 digits' do
      assert_equal '01', Nummernkreis.new('dd').to_s
    end

    it 'parses # as one generated digit' do
      assert_equal '1', Nummernkreis.new('#').to_s
    end

    it 'parses ## as two generated digits' do
      assert_equal '01', Nummernkreis.new('##').to_s
    end

    it 'parses ##### as three generated digits' do
      assert_equal '00001', Nummernkreis.new('#####').to_s
    end

    it 'parses dash as string' do
      assert_equal '-', Nummernkreis.new('-').to_s
    end

    it 'parses combined statements' do
      assert_equal '20190001', Nummernkreis.new('yyyy####').to_s
      assert_equal '190301-01', Nummernkreis.new('yymmdd-##').to_s
      assert_equal '0101-2019', Nummernkreis.new('dd##-yyyy').to_s
    end

    it 'cannot have more than one number part' do
      assert_raises Nummernkreis::Error do
        Nummernkreis.new('yy##dd##')
      end
    end
  end

  describe '#next' do
    it 'returns the next number in the range' do
      range = Nummernkreis.new('yymmdd-##')
      assert_equal '190301-01', range.to_s
      assert_equal '190301-02', range.next
      assert_equal '190301-03', range.next

      range = Nummernkreis.new('####-ddmmyy')
      assert_equal '0001-010319', range.to_s
      assert_equal '0002-010319', range.next
      assert_equal '0003-010319', range.next
    end
  end

  describe '#parse' do
    it 'sets the number and returns the number range' do
      range = Nummernkreis.new('yymmdd-##').parse('181231-04')
      assert_equal '181231-04', range.to_s
      assert_equal '181231-05', range.next
      assert_equal '181231-06', range.next
    end
  end

  describe '#next(now: true)' do
    it 'returns the next number in the range' do
      range = Nummernkreis.new('yymmdd-##').parse('181231-04')
      assert_equal '181231-04', range.to_s
      assert_equal '190301-01', range.next(now: true)
      assert_equal '190301-02', range.next
      assert_equal '190301-03', range.next(now: true)
    end
  end

end
