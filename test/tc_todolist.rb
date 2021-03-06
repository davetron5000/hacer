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
    todo = TodoInternal.new("FOO",1)
    File.open(@filename,'w') { |file| YAML.dump([todo],file) }
    expected_contents = YAML.dump([todo])
    todo_list = Todolist.new(@filename)
    contents = File.readlines(@filename).join("\n") + "\n"
    assert_equal expected_contents,contents,"#{@filename} got overwritten when it shouldn't have been"
  end

  def test_bad_format_causes_exception
    File.open(@filename,'w') { |file| file.puts "FOO" }
    assert_raises(ArgumentError) { todo_list = Todolist.new(@filename) }
    File.open(@filename,'w') { |file| YAML.dump(["FOO"],file) }
    assert_raises(ArgumentError) { todo_list = Todolist.new(@filename) }
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
    assert_equal 2,todo_list.list(:incomplete).size
    assert_equal 2,todo_list.size(:incomplete)
  end

  def test_list_persists
    todo_list = Todolist.new(@filename)
    todo1 = todo_list.create("Take out the garbage")
    todo2 = todo_list.create("Rake some leaves")
    new_todo_list_ref = Todolist.new(@filename)
    list = new_todo_list_ref.list
    assert_equal 2,list.size
    assert_equal "Take out the garbage",list[0].text
    assert_equal "Rake some leaves",list[1].text
    assert_equal todo1.todo_id,list[0].todo_id
    assert_equal todo2.todo_id,list[1].todo_id
  end

  def test_ids_increment
    todo_list = Todolist.new(@filename)
    todo1 = todo_list.create("Take out the garbage")
    todo2 = todo_list.create("Rake some leaves")
    assert todo2.todo_id > todo1.todo_id,"Expected ids to increment, however todo2 had id of #{todo2.todo_id} and todo1 had an id of #{todo1.todo_id}"
  end

  def test_completed
    todo_list = Todolist.new(@filename)
    todo1 = todo_list.create("Take out the garbage")
    todo2 = todo_list.create("Rake some leaves")
    todo_list.complete(todo1)
    assert todo1.completed?
    assert_equal 1,todo_list.size
    assert_equal "Rake some leaves",todo_list.list[0].text
    assert_equal 2,todo_list.size(:all)
    assert_equal "Take out the garbage",todo_list.list(:all)[0].text
    assert todo_list.list(:all)[0].completed?
    assert_equal "Rake some leaves",todo_list.list(:all)[1].text
  end

  def test_completed_persists
    todo_list = Todolist.new(@filename)
    todo1 = todo_list.create("Take out the garbage")
    todo2 = todo_list.create("Rake some leaves")
    todo_list.complete(todo1)
    todo_list = Todolist.new(@filename)
    assert todo_list.list(:all)[0].completed?
  end

  def test_valid_list_args
    todo_list = Todolist.new(@filename)
    todo1 = todo_list.create("Take out the garbage")
    todo2 = todo_list.create("Rake some leaves")
    assert_raises(ArgumentError) { todo_list.list(:foo) }
    assert_raises(ArgumentError) { todo_list.size(:foo) }
  end


  def test_next_id_is_initialized
    todo_list = Todolist.new(@filename)
    todo1 = todo_list.create("Take out the garbage")
    todo2 = todo_list.create("Rake some leaves")
    todo_list = Todolist.new(@filename)
    todo_list.instance_eval do
      def spy_on_next_id
        next_id
      end
    end
    assert_equal todo2.todo_id + 1,todo_list.spy_on_next_id
  end

  def test_clean
    todo_list = Todolist.new(@filename)
    todo1 = todo_list.create("Take out the garbage")
    todo2 = todo_list.create("Rake some leaves")
    todo_list.complete(todo1)
    todo_list.clean!
    assert_equal 1,todo_list.size(:all)
    todo_list = Todolist.new(@filename)
    assert_equal 1,todo_list.size(:all)
  end
end
