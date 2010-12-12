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
  end
end
