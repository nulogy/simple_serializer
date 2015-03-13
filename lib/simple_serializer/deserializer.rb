# Simple framelet for deserialization
#
#    class SomeDeserializer < SimpleSerializer::Deserializer
#      data_attributes :site_id, :name, :category_id, :integration_key
#
#      def integration_key(old_integration_key)
#        "XX#{@data[:other_attr]}XX#{old_integration_key}XX"
#      end
#
#      def set_category_id(category_id)
#        object.category = InventoryStatusCategory.from_id(category_id)
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
    attr_accessor :_attributes

    def inherited(base)
      base._attributes = []
    end

    def attributes(*attrs)
      @_attributes.concat attrs

      attrs.each do |attr|
        define_method attr do
          @data[attr]
        end unless method_defined?(attr)

        define_method "set_#{attr}" do
          object.send("#{attr}=", send(attr))
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
    self.class._attributes.dup.each do |name|
      send("set_#{name}")
    end
    object
  end
end
end
