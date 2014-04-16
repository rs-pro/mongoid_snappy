require 'rails_admin/adapters/mongoid'
begin
  require 'rails_admin/adapters/mongoid/property'
rescue Exception => e 
end

module RailsAdmin
  module Adapters
    module Mongoid
      class Property
        alias_method :type_without_mongoid_snappy, :type
        def type
          if property.type.to_s == 'Mongoid::Snappy'
            :mongoid_snappy
          else
            type_without_mongoid_snappy
          end
        end
      end
    end
  end
end

module RailsAdmin
  module Config
    module Fields
      module Types
        class MongoidSnappy < RailsAdmin::Config::Fields::Types::Text
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types::register(self)

          register_instance_option :pretty_value do
            if value.respond_to?(:data)
              ::Snappy.inflate(value.data).force_encoding('UTF-8')
            else
              value
            end
          end

          register_instance_option :formatted_value do
            if value.respond_to?(:data)
              ::Snappy.inflate(value.data).force_encoding('UTF-8')
            else
              value
            end
          end
        end
      end
    end
  end
end
