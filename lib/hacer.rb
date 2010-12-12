require 'yaml'

module Hacer
  class Todolist
    def initialize(filename)
      File.open(filename,'w') do |file|
        YAML.dump([],file)
      end
    end
  end
end
