require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require "minitest/reporters"
Minitest::Reporters.use!

require_relative 'todolist'

class TodoListTest < MiniTest::Test

  def setup
    @todo1 = Todo.new("Buy milk")
    @todo2 = Todo.new("Clean room")
    @todo3 = Todo.new("Go to gym")
    @todos = [@todo1, @todo2, @todo3]

    @empty_list = TodoList.new("Empty List")
    @list = TodoList.new("Today's Todos")
    @todos.each { |todo| @list.add(todo) }
  end

  # Your tests go here. Remember they must start with "test_"

  def test_find_by_title
    found = @list.find_by_title("Buy milk")
    assert_equal(@todo1, found)
    found = @list.find_by_title("Clean room")
    assert_equal(@todo2, found)
    found = @list.find_by_title("Go to gym")
    assert_equal(@todo3, found)
    found = @list.find_by_title("this doesn't exist")
    assert_nil(found)
  end

  def test_to_a
    assert_equal(@todos, @list.to_a)
    assert_empty(@empty_list.to_a)
  end

  def test_size
    assert_equal(@todos.size, @list.size)
    assert_equal(0, @empty_list.size)
  end

  def test_first
    assert_equal(@todos.first, @list.first)
    assert_nil(@empty_list.first)
  end
  
  def test_last
    assert_equal(@todos.last, @list.last)
    assert_nil(@empty_list.first)
  end

  def test_shift
    first = @list.shift
    @todos.shift
    assert_equal(@todo1, first)
    assert_equal(@todos, @list.to_a)
    assert_nil(@empty_list.shift)
  end

  def test_pop
    last = @list.pop
    @todos.pop
    assert_equal(@todo3, last)
    assert_equal(@todos, @list.to_a)
    assert_nil(@empty_list.pop)
  end

  def test_done
    assert_equal(false, @list.done?)
    assert_equal(true, @empty_list.done?)
  end

  def test_add_non_todo
    assert_raises(TypeError) { @list.add(12) }
    assert_raises(TypeError) { @list.add("todo") }
    assert_raises(TypeError) { @list.add(TodoList.new("List")) }
  end

  def test_shovel_operator
    assert_raises(TypeError) { @list << 12 }
    assert_raises(TypeError) { @list << TodoList.new("List") }

    add_todo = Todo.new("Test the shovel operator")
    @list << add_todo
    @todos << add_todo
    assert_equal(@todos, @list.to_a)
    @empty_list << add_todo
    assert_equal(1, @empty_list.size)
    assert_equal([add_todo], @empty_list.to_a)
  end

  def test_add
    add_todo = Todo.new("Test the add method")
    @list.add(add_todo)
    @todos << add_todo
    assert_equal(@todos, @list.to_a)
    @empty_list.add(add_todo)
    assert_equal(1, @empty_list.size)
    assert_equal([add_todo], @empty_list.to_a)
  end

  def test_item_at
    assert_raises(IndexError) { @list.item_at(@list.size + 1) }
    assert_raises(IndexError) { @empty_list.item_at(0) }

    @todos.each_index do |index|
      assert_equal(@todos[index], @list.item_at(index))
    end
  end

  def test_mark_done_at
    assert_raises(IndexError) { @list.mark_done_at(-(@list.size + 1)) }
    assert_raises(IndexError) { @list.mark_done_at(@list.size + 1) }
    assert_raises(IndexError) { @empty_list.mark_done_at(0) }

    @todos.each { |todo| todo.undone! }
    @todos.each_index { |index| @list.mark_done_at(index) }
    assert_equal(true, @list.done?)

    @todos.each { |todo| assert_equal(true, todo.done?) }
  end

  def test_mark_undone_at
    assert_raises(IndexError) { @list.mark_undone_at(-(@list.size + 1)) }
    assert_raises(IndexError) { @list.mark_undone_at(@list.size + 1) }
    assert_raises(IndexError) { @empty_list.mark_undone_at(0) }

    @todos.each { |todo| todo.done! }
    @todos.each_index { |index| @list.mark_undone_at(index) }
    assert_equal(false, @list.done?)

    @todos.each { |todo| assert_equal(false, todo.done?) }
  end

  def test_done!
    @list.done!
    @todos.each { |todo| assert_equal(true, todo.done?) }
    assert_equal(true, @list.done?)
    @empty_list.done!
    assert_empty(@empty_list.to_a)
  end

  def test_remove_at
    assert_raises(IndexError) { @list.remove_at(-(@list.size + 1)) }
    assert_raises(IndexError) { @list.remove_at(@list.size + 1) }
    assert_raises(IndexError) { @empty_list.remove_at(0) }

    while @todos.size > 0
      random_index = rand(0...@todos.size)
      assert_equal(@todos.delete_at(random_index), @list.remove_at(random_index))
      assert_equal(@todos, @list.to_a)
    end

    assert_empty(@list.to_a)
  end

  def test_to_s
    output = <<~OUTPUT.chomp
    ---- Today's Todos ----
    [ ] Buy milk
    [ ] Clean room
    [ ] Go to gym
    OUTPUT

    empty_output = <<~EMPTY_OUTPUT.chomp
    ---- Empty List ----

    EMPTY_OUTPUT

    one_done_output = <<~ONE_DONE_OUTPUT.chomp
    ---- Today's Todos ----
    [ ] Buy milk
    [X] Clean room
    [ ] Go to gym
    ONE_DONE_OUTPUT

    done_output = <<~DONE_OUTPUT.chomp
    ---- Today's Todos ----
    [X] Buy milk
    [X] Clean room
    [X] Go to gym
    DONE_OUTPUT

    assert_equal(output, @list.to_s)
    assert_equal(empty_output, @empty_list.to_s)
    @list.done!
    assert_equal(done_output, @list.to_s)
    @list.mark_all_undone
    @list.mark_done_at(1)
    assert_equal(one_done_output, @list.to_s)
  end

  def test_each
    todo_index = 0
    @list.each do |todo|
      assert_equal(@todos[todo_index], todo)
      todo_index += 1
    end
    assert_equal(@list, @list.each { |_| nil } )
  end

  def test_select
    selected = @list.select { |_| true }
    assert_instance_of(TodoList, selected)
    refute_same(selected, @list)
    assert_equal(selected, @list)
  end

  def test_all_done
    assert_empty(@list.all_done.to_a)
    @list.mark_all_done
    done_todos = @list.all_done
    assert_equal(@list.size, done_todos.size)
    assert_equal(true, done_todos.done?)
  end

  def test_all_not_done
    not_done_todos = @list.all_not_done
    assert_equal(@list.size, not_done_todos.size)
    assert_equal(true, not_done_todos.to_a.all? { |todo| !todo.done? })
    @list.mark_all_done
    assert_empty(@list.all_not_done.to_a)
  end

  def test_mark_done
    @list.mark_done(@todo1.title)
    assert_equal(true, @todo1.done?)
    assert_equal(false, @todo2.done?)
    assert_equal(false, @todo3.done?)
    @list.mark_done(@todo3.title)
    assert_equal(true, @todo1.done?)
    assert_equal(false, @todo2.done?)
    assert_equal(true, @todo3.done?)
    @list.mark_done(@todo2.title)
    assert_equal(true, @todo1.done?)
    assert_equal(true, @todo2.done?)
    assert_equal(true, @todo3.done?)
  end
end