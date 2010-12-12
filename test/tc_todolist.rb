require 'hacer.rb'
require 'test/unit'
require 'fileutils'
require 'fakefs'
require 'fakefs/safe'

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
end
