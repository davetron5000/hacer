require 'yaml'

module Hacer
  class Todolist
    def initialize(filename)
      if File.exists?(filename)
        contents = File.open(filename) { |file| YAML.load(file) }
        raise ArgumentError.new("#{filename} doesn't appear to be an hacer todo list") unless contents.kind_of? Array
      else
        File.open(filename,'w') do |file|
          YAML.dump([],file)
        end
      end
    end
  end
end
