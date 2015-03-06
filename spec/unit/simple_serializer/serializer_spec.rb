require 'unit_spec_helper'
require 'simple_serializer/serializer'

describe SimpleSerializer::Serializer do

  let(:object) { double }

  class TestSerializer < SimpleSerializer::Serializer
    attributes :field1, :field2
  end

  describe 'serialize' do
    it 'sets attributes' do
      object = double(field1: 1, field2: 2)

      result = TestSerializer.serialize(object)

      expect(result).to eq({field1: 1, field2: 2})
    end

    describe 'value transformation' do
      class TestTransformingSerializer < SimpleSerializer::Serializer
        attributes :field1

        def field1
          object.field1 + 1
        end
      end

      it 'maps values' do
        object = double(field1: 1)

        result = TestTransformingSerializer.serialize(object)

        expect(result).to eq({field1: 2})
      end
    end
  end

  describe 'serialize_array' do
    it 'serializes many objects' do
      object1 = double(field1: 1, field2: 2)
      object2 = double(field1: 3, field2: 4)

      result = TestSerializer.serialize_array([object1, object2])

      expect(result).to eq([{field1: 1, field2: 2}, {field1: 3, field2: 4}])
    end
  end
end
