require 'hacer.rb'
require 'test/unit'
require 'fileutils'
require 'fakefs'
require 'fakefs/safe'
require 'yaml'

class TC_testTodoList < Test::Unit::TestCase
  include FileUtils
  include Hacer

  def setup
    FakeFS.activate!
    @filename = '/tmp/todo'
    rm_f(@filename)
  end

  def teardown
    FakeFS.deactivate!
  end

  def test_create_new_todolist
    assert !File.exists?(@filename),"Expected #{@filename} not to exist"
    todo_list = Todolist.new(@filename)
    assert File.exists?(@filename),"Expected todolist file #{@filename} to have been created"
  end

  def test_use_existing_todolist
    File.open(@filename,'w') { |file| YAML.dump(["FOO"],file) }
    expected_contents = YAML.dump(["FOO"])
    todo_list = Todolist.new(@filename)
    contents = File.readlines(@filename).join("\n") + "\n"
    assert_equal expected_contents,contents,"#{@filename} got overwritten when it shouldn't have been"
  end

  def test_bad_form_fat_causes_exception
    File.open(@filename,'w') { |file| file.puts "FOO" }
    assert_raises ArgumentError do 
      todo_list = Todolist.new(@filename)
    end
  end

  def test_create
    todo_list = Todolist.new(@filename)
    assert_equal 0,todo_list.size
    todo = todo_list.create("Take out the garbage")
    assert_equal 1,todo_list.size
    assert todo.kind_of? Todo
    assert_equal "Take out the garbage",todo.text
  end

  def test_create_many
    todo_list = Todolist.new(@filename)
    assert_equal 0,todo_list.size
    todo_list.create("Take out the garbage")
    todo_list.create("Take out the garbage")
    todo_list.create("Take out the garbage")
    todo_list.create("Take out the garbage")
    assert_equal 4,todo_list.size
  end

  def test_list
    todo_list = Todolist.new(@filename)
    todo_list.create("Take out the garbage")
    todo_list.create("Rake some leaves")
    todos = todo_list.list
    assert_equal 2,todos.size
    assert todos[0].kind_of?(Todo),"Expected a Todo, but got a #{todos[0].class}"
  end

  def test_list_persists
    todo_list = Todolist.new(@filename)
    todo_list.create("Take out the garbage")
    todo_list.create("Rake some leaves")
    new_todo_list_ref = Todolist.new(@filename)
    list = new_todo_list_ref.list
    assert_equal 2,list.size
    assert_equal "Take out the garbage",list[0].text
    assert_equal "Rake some leaves",list[1].text
  end
end
