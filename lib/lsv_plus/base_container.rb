module LSVplus
  class BaseContainer
    class UnknownAttribute < StandardError
      def initialize(attribute)
        @attribute = attribute
      end

      def to_s
        "Attribute #{@attribute} is unknown"
      end
    end

    def initialize(attributes)
      attributes.each do |key, value|
        raise UnknownAttribute, key unless respond_to?(key)
        instance_variable_set("@#{key}", value)
      end
    end
  end
end
