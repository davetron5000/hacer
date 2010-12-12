require 'yaml'

module Hacer
  class Todolist

    # Create a new Todolist stored in the given filename
    #
    # filename - String containing the name of the file to create.  If the file exists, it will
    #            be parsed as an Hacer todolist.  If this isn't possible, an ArgumentError will be raised
    def initialize(filename)
      if File.exists?(filename)
        contents = File.open(filename) { |file| YAML.load(file) }
        raise ArgumentError.new("#{filename} doesn't appear to be an hacer todo list") unless contents.kind_of? Array
      else
        File.open(filename,'w') do |file|
          YAML.dump([],file)
        end
      end
      @todos = []
    end


    # Create a new todo and store it in this list
    def create(todo_text)
      todo = Todo.new(todo_text)
      @todos << todo
      todo
    end

    # Return all todos in this Todolist
    def list
      @todos
    end

    # Returns the size of the todolist as an Int
    def size
      @todos.size
    end
  end

  class Todo
    attr_reader :text
    def initialize(text)
      @text = text
    end
  end
end
