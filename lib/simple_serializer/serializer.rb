# Simple framelet for serialization.
#
# API compatible with ActiveModel::Serializer but without all the complexity
# and dependence on ActiveModel
#
#    class SomeSerializer < SimpleSerializer::Serializer
#      hash_attributes :id, :name, :category_id, :errors
#
#      def category_id
#        object.category.try(:id)
#      end
#
#      def errors
#        ActiveModelErrorsSerializer.serialize_errors(object.errors, true) if object.errors.any?
#      end
#    end
#
# Usage:
#
#    SomeSerializer.serialize(object)
#    SomeSerializer.new(object).serialize
#
#    SomeSerializer.serialize_array([object])
#
module SimpleSerializer
  class Serializer
    class << self
      attr_accessor :_hash_attributes

      def inherited(base)
        base._hash_attributes = []
      end

      def hash_attributes(*attrs)
        @_hash_attributes.concat attrs

        attrs.each do |attr|
          define_method attr do
            object.send(attr)
          end unless method_defined?(attr)
        end
      end

      def serialize_array(objects)
        objects.map { |obj| serialize(obj) }
      end

      def serialize(object)
        self.new(object).serialize
      end

      alias :as_json :serialize
    end

    attr_accessor :object

    def initialize(object, _={})
      @object = object
    end

    def extract_attributes
      self.class._hash_attributes.dup.each_with_object({}) do |name, hash|
        hash[name] = send(name)
      end
    end

    def serialize(_={})
      return nil if object.nil?
      extract_attributes
    end
    alias :as_json :serialize
  end
end
