module Kingpin
  class TaskSequence < Task
    def self.sequence
      @sequence
    end

    def run(*params)
      self.class.sequence.each do |task|
        task.new.run *params
      end
    end
  end
end
