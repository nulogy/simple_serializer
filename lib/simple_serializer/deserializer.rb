# Simple framelet for deserialization
#
#    class SomeDeserializer < SimpleSerializer::Deserializer
#      object_attributes :site_id, :name, :category, :integration_key
#
#      def integration_key
#        "XX#{data[:other_attr]}XX#{data[:integration_key]}XX"
#      end
#
#      # Set a field regardless of presence in data hash
#      def set_site_id
#        object.site_id = 99
#      end
#    end
#
# Usage:
#
#    SomeDeserializer.deserialize(object, data)
#    SomeDeserializer.new(object, data).deserialize
#
#    SomeDeserializer.deserialize_array([object1, object2, ...], [data1, data2, ...])
#
module SimpleSerializer
  class Deserializer
    class << self
      attr_accessor :_object_attributes

      def inherited(base)
        base._object_attributes = []
      end

      def object_attributes(*attrs)
        @_object_attributes.concat attrs

        attrs.each do |attr|
          define_method attr do
            @data[attr]
          end unless method_defined?(attr)

          define_method "set_#{attr}" do
            object.send("#{attr}=", send(attr)) if @data.has_key?(attr)
          end unless method_defined?("set_#{attr}")
        end
      end

      def deserialize_array(objects, data)
        objects.zip(data).map { |obj, datum| deserialize(obj, datum) }
      end

      def deserialize(object, data)
        self.new(object, data).deserialize
      end
    end

    attr_reader :object, :data

    def initialize(object, data)
      @object = object
      @data = data
    end

    def deserialize
      self.class._object_attributes.dup.each do |name|
        send("set_#{name}")
      end
      object
    end
  end
end
