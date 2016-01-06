module LSVplus
  module Errors
    class Base < StandardError; end
    class InvalidAttribute < Base
      def initialize(reason)
        @reason = reason
      end

      def to_s
        "Attribute #{@@attribute} is invalid: #{@reason}"
      end
    end
  end
end
