require 'lsv_plus/errors'

module LSVplus
  class BaseContainer
    class UnknownAttribute < LSVplus::Errors::Base
      def initialize(attribute)
        @attribute = attribute
      end

      def to_s
        "Attribute #{@attribute} is unknown"
      end
    end

    class MissingAttribute < LSVplus::Errors::Base
      def initialize(attribute)
        @attribute = attribute
      end

      def to_s
        "Attribute :#{@attribute} is missing"
      end
    end

    def initialize(attributes)
      validate attributes
      set_attributes attributes
    end

    def validate(attributes)
      validate_presence_of_required_attributes(attributes)
    end

    def set_attributes(attributes)
      attributes.each do |key, value|
        raise UnknownAttribute, key unless self.class::ATTRIBUTES.include?(key)
        instance_variable_set("@#{key}", value)
      end
    end

    def validate_presence_of_required_attributes(attributes)
      self.class::ATTRIBUTES.each do |attribute|
        raise MissingAttribute, attribute unless attributes.key?(attribute)
      end
    end
  end
end
