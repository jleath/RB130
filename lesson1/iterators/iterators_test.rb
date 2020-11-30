require 'minitest/autorun'
require 'minitest/reporters'

require_relative 'iterators'

MiniTest::Reporters.use!

class IteratorsTest < MiniTest::Test
  def test_each
    result = []
    each([1, 2, 3, 4]) { |val| result << val * 2 }
    assert_equal([2, 4, 6, 8], result)
  end

  def test_times
    result = []
    times(5) { |val| result << val }
    assert_equal([0, 1, 2, 3, 4], result)
  end

  def test_select
    assert_equal([1, 3, 5], select([1, 2, 3, 4, 5]) { |val| val.odd? })
  end

  def test_reduce
    assert_equal(10, reduce([1, 2, 3, 4]) { |acc, val| acc + val })
    assert_equal(20, reduce([1, 2, 3, 4], 10) { |acc, val| acc + val })
    assert_equal([2, 4, 6, 8], reduce([1, 2, 3, 4], []) { |acc, val| acc << (val * 2) })
    assert_equal("abc", reduce(['a', 'b', 'c']) { |acc, val| acc += val })
    assert_equal([1, 2, 'a', 'b'], reduce([[1, 2], ['a', 'b']]) { |acc, val| acc + val })
  end
end