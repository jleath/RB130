def times(n)
  i = 0
  while i < n
    yield(i)
    i += 1
  end
  n
end

def each(container)
  index = 0
  while index < container.size
    yield(container[index])
    index += 1
  end
  container
end

def select(container)
  result = []
  index = 0
  while index < container.size
    curr_item = container[index]
    result << curr_item if yield(curr_item)
    index += 1
  end
  result
end

def reduce(container, start = nil)
  index = start.nil? ? 1 : 0
  start = start.nil? ? container[0] : start
  while index < container.size
    start = yield(start, container[index])
    index += 1
  end
  start
end

# def each(container)
#   times(container.size) { |index| yield(container[index]) }
#   container
# end

# def select(container)
#   result = []
#   each(container) { |val| result << val if yield(val) }
#   result
# end

# def reduce(container, start = 0)
#   each(container) { |val| start = yield(start, val) }
#   start
# end

puts each([1, 2, 3, 4]) { |val| puts val } == [1, 2, 3, 4]
puts select([1, 2, 3, 4]) { |val| val.odd? } == [1, 3]
puts select([1, 2, 3, 4]) { |val| val.nil? } == []
puts select([1, 2, 3, 4]) { |num| puts num } == []
puts select([1, 2, 3, 4]) { |num| num + 1 } == [1, 2, 3, 4]

puts reduce([1, 2, 3, 4, 5]) { |acc, num| acc + num } == 15
puts reduce([1, 2, 3, 4, 5], 10) { |acc, num| acc + num } == 25
# puts reduce([1, 2, 3, 4, 5]) { |acc, num| acc + num if num.odd? } == 9

p reduce(['a', 'b', 'c']) { |acc, value| acc += value }     # => 'abc'
p reduce([[1, 2], ['a', 'b']]) { |acc, value| acc + value } # => [1, 2, 'a', 'b']