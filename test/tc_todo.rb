require 'hacer.rb'
require 'test/unit'

class TC_testTodo < Test::Unit::TestCase

  def test_cannot_create_a_todo
    assert_raises(RuntimeError) do
      Hacer::Todo.new
    end
  end

  def test_to_s
    todo = Hacer::TodoInternal.new("Foo",1)
    assert_equal "Todo(1,Foo)",todo.to_s
    todo.complete
    assert_equal "Todo(1,Foo,completed)",todo.to_s
  end
end
