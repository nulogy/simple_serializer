require 'unit_spec_helper'
require 'simple_serializer/deserializer'

describe SimpleSerializer::Deserializer do

  let(:object) { double }

  class TestDeserializer < SimpleSerializer::Deserializer
    attributes :field1
  end

  describe 'deserialize' do
    it 'sets attributes' do
      attrs = {field1: 1}
      expect(object).to receive(:field1=).with(1)

      result = TestDeserializer.deserialize(object, attrs)
      expect(result).to be object
    end

    describe 'attribute value transformation' do
      class TestTransformingDeserializer < SimpleSerializer::Deserializer
        attributes :field1

        def field1
          data[:field1] + 1
        end
      end

      it 'maps values' do
        attrs = {field1: 1}
        expect(object).to receive(:field1=).with(2)

        TestTransformingDeserializer.deserialize(object, attrs)
      end
    end

    describe 'attribute key transformation' do
      class TestMappingDeserializer < SimpleSerializer::Deserializer
        attributes :association

        def set_association
          object.association = data[:association_id]
        end
      end

      it 'maps keys' do
        attrs = {association_id: 1}
        expect(object).to receive(:association=).with(1)

        TestMappingDeserializer.deserialize(object, attrs)
      end
    end
  end

  describe 'deserialize_array' do
    it 'deserializes many objects' do
      data = [{field1: 1}, {field1: 3}]
      expect(object).to receive(:field1=).with(1)

      object2 = double
      expect(object2).to receive(:field1=).with(3)

      result = TestDeserializer.deserialize_array([object, object2], data)
      expect(result).to eq [object, object2]
    end
  end
end
