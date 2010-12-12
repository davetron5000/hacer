require 'hacer.rb'
require 'test/unit'

class TC_testTodo < Test::Unit::TestCase

  def test_cannot_create_a_todo
    assert_raises(RuntimeError) do
      Hacer::Todo.new
    end
  end
end
