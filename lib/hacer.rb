require 'yaml'

module Hacer
  # A todo list manages a list of Todo items.  It holds all Todo items, even completed ones, until you
  # call clean!
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
      todo_with_biggest_id = @todos.max { |a,b| a.todo_id <=> b.todo_id }
      @next_id  = todo_with_biggest_id.nil? ? 0 : todo_with_biggest_id.todo_id + 1
    end

    # Create a new todo and store it in this list
    #
    # todo_text - String containing the text of the todo item
    #
    # Returns the Todo item created
    def create(todo_text)
      todo = Todo.new(todo_text,next_id)
      @todos << todo
      save_todos
      todo
    end

    # Completes this todo item
    #
    # todo - Todo to complete
    def complete(todo)
      todo.complete
    end

    # Return all todos in this Todolist as an Array of Todo
    def list(show=:incomplete)
      case show
      when :incomplete: @todos.select { |todo| !todo.completed? }
      when :all: @todos
      else
        raise ArgumentError.new("Only :incomplete or :all are allowed")
      end
    end

    # Returns the size of the todolist as an Int
    def size(show=:incomplete)
      return list(show).size
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

    @next_id = 0
    def next_id
      next_id = @next_id
      @next_id += 1
      next_id
    end
  end

  class Todo
    attr_reader :text
    attr_reader :todo_id
    
    def initialize(text,todo_id)
      @todo_id = todo_id
      @text = text
      @completed = false
    end

    def complete; @completed = true; end
    def completed?; @completed; end

  end
end
