def each(collection)
  index = 0
  while index < collection.size
    yield(collection[index])
    index += 1
  end
  collection
end

def select(collection)
  index = 0
  result = []
  while index < collection.size
    current_item = collection[index]
    result << current_item if yield(current_item)
    index += 1
  end
  result
end

def select(collection)
  result = []
  each(collection) do |value|
    result << value if yield(value)
  end
  result
end

def times(n)
  iteration = 0
  while iteration < n
    yield(iteration)
    iteration += 1
  end
  n
end

def times(n)
  each((0...n).to_a) { |val| yield(val) }
  n
end

def reduce(collection, default = nil)
  index = default.nil? ? 1 : 0
  accumulator = default.nil? ? collection[0] : default
  while index < collection.size
    accumulator = yield(accumulator, collection[index])
    index += 1
  end
  accumulator
end