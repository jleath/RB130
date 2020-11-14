require 'minitest/autorun'
require 'minitest/reporters'

Minitest::Reporters.use!

def square_root(n)
  Math.sqrt(n)
end

describe 'square_root test case' do
  it 'works with perfect squares' do
    _(square_root(9)).must_equal 3
  end

  it 'returns 0 as the square root of 0' do
    _(square_root(0)).must_equal 0
  end

  it 'works with non-perfect squares' do
    _(square_root(2)).must_be_close_to 1.4142
  end

  it 'raises an exception for negative numbers' do
    _(proc { square_root(-3) }).must_raise Math::DomainError
  end
end

