class Dummy
  include Mongoid::Document

  field :migrate_test, type: String
  field :long_text, type: Mongoid::Snappy
end

class Migrated
  include Mongoid::Document
  store_in collection: 'dummies'
  field :migrate_test, type: Mongoid::Snappy
end