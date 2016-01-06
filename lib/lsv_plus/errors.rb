module LSVplus
  module Errors
    class Base < StandardError; end
    class InvalidAttribute < Base
      def initialize(reason)
        @reason = reason
      end

      def to_s
        "Attribute #{self.class::ATTRIBUTE} is invalid: #{@reason}"
      end
    end
  end
end
