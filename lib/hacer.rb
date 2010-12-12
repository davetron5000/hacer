require 'yaml'

module Hacer
  class Todolist

    # Create a new Todolist stored in the given filename
    #
    # filename - String containing the name of the file to create.  If the file exists, it will
    #            be parsed as an Hacer todolist.  If this isn't possible, an ArgumentError will be raised
    def initialize(filename)
      @filename = filename
      if File.exists?(@filename)
        @todos = File.open(@filename) { |file| YAML.load(file) }
        raise ArgumentError.new("#{@filename} doesn't appear to be an hacer todo list") unless valid_todolist?
      else
        @todos = []
        save_todos
      end
    end

    # Create a new todo and store it in this list
    def create(todo_text)
      todo = Todo.new(todo_text)
      @todos << todo
      save_todos
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

    private

    # Saves the todos into the filename
    def save_todos
      File.open(@filename,'w') do |file|
        YAML.dump(@todos,file)
      end
    end

    # Returns true if what we parsed into @todos is a valid todo list
    def valid_todolist?
      return false unless @todos.kind_of? Array
      @todos.each do |todo|
        return false unless todo.kind_of? Todo
      end
      true
    end

  end

  class Todo
    attr_reader :text
    def initialize(text)
      @text = text
    end
  end
end
