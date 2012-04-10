module Diaspora
  module Cluster
    module Creator
      class StarSystem
        attr_reader :technology
        attr_reader :resources
        attr_reader :environment

        def initialize
          @technology = roller.roll
          @resources = roller.roll
          @environment = roller.roll
        end
        alias_method :resource, :resources
        protected
        def roller
          @roller ||= FateRoll.new(4)
        end
      end
    end
  end
end