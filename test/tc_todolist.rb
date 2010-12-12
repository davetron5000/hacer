require 'hacer.rb'
require 'test/unit'
require 'fileutils'
require 'fakefs'
require 'fakefs/safe'
require 'yaml'

class TC_testTodoList < Test::Unit::TestCase
  include FileUtils
  include Hacer


  def test_create_new_todolist
    FakeFS do
      filename = "/tmp/todo"
      rm(filename)
      assert !File.exists?(filename),"Expected #{filename} not to exist"
      todo_list = Todolist.new(filename)
      assert File.exists?(filename),"Expected todolist file #{filename} to have been created"
    end
  end

  def test_use_existing_todolist
    FakeFS do
      filename = "/tmp/todo"
      rm(filename)
      File.open(filename,'w') { |file| YAML.dump(["FOO"],file) }
      expected_contents = YAML.dump(["FOO"])
      todo_list = Todolist.new(filename)
      contents = File.readlines(filename).join("\n") + "\n"
      assert_equal expected_contents,contents,"#{filename} got overwritten when it shouldn't have been"
    end
  end

  def test_bad_format_causes_exception
    FakeFS do
      filename = "/tmp/todo"
      rm(filename)
      File.open(filename,'w') { |file| file.puts "FOO" }
      assert_raises ArgumentError do 
        todo_list = Todolist.new(filename)
      end
    end
  end
end
