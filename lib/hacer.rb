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
      @size = 0
    end

    # Create a new todo and store it in this list
    def create(todo_text)
      @size += 1
      return Todo.new(todo_text)
    end

    # Return all todos in this Todolist
    def list
      self.size.times.map(&:to_s)
    end

    # Returns the size of the todolist as an Int
    attr_reader :size
  end

  class Todo
    attr_reader :text
    def initialize(text)
      @text = text
    end
  end
end
