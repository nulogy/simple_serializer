# SimpleSerializer

Simple framelet for serializing/deserializing objects to hashes.

API compatible with ActiveModel::Serializer but without all the complexity
and NO ROOT KEYS!

# Serializer Usage

```
class SomeSerializer < SimpleSerializer::Serializer
  hash_attributes :id, :name, :category_id, :errors

  def category_id
    object.category.try(:id)
  end

  def errors
    ActiveModelErrorsSerializer.serialize_errors(object.errors, true) if object.errors.any?
  end
end
```

Use it:

```
SomeSerializer.serialize(object)
SomeSerializer.new(object).serialize

SomeSerializer.serialize_array([object])
```

# Deserializer Usage

```
class SomeDeserializer < SimpleSerializer::Deserializer
  object_attributes :site_id, :name, :category_id, :integration_key

  def integration_key(old_integration_key)
    "XX#{@data[:other_attr]}XX#{old_integration_key}XX"
  end

  def set_site_id
    object.site_id = 99
  end
end
```

Use it:

```
SomeDeserializer.deserialize(object, data)
SomeDeserializer.new(object, data).deserialize

SomeDeserializer.deserialize_array([object1, object2, ...], [data1, data2, ...])
```