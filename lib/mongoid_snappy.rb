# coding: utf-8

require 'mongoid_snappy/version'
require 'snappy'

module Mongoid
  class Snappy
    def initialize(data)
      @data = data
    end

    def to_s
      @data
    end

    def inspect
      '"' + @data + '"'
    end

    def ==(other)
      if other.class == self.class
        other.to_s == to_s
      elsif other.class == String
        @data == other
      else
        false
      end
    end

    def coerce(something)
      [self, something]
    end

    def mongoize
      Moped::BSON::Binary.new(:generic, ::Snappy.deflate(@data))
    end

    class << self

      # Get the object as it was stored in the database, and instantiate
      # this custom class from it.
      def demongoize(object)
        if object.is_a?(Moped::BSON::Binary)
          Mongoid::Snappy.new(::Snappy.inflate(object.data))
        elsif object.is_a?(String)
          Mongoid::Snappy.new(object)
        else
          object
        end
      end

      # Takes any possible object and converts it to how it would be
      # stored in the database.
      def mongoize(object)
        case
          when object.is_a?(Mongoid::Snappy) then object.mongoize
          when object.is_a?(String) then Mongoid::Snappy.new(object).mongoize
          else object
        end
      end

      # Converts the object that was supplied to a criteria and converts it
      # into a database friendly form.
      def evolve(object)
        case object
          when Mongoid::Snappy then object.mongoize
          when String then Mongoid::Snappy.new(object).mongoize
          else object
        end
      end
    end
  end
end

if Object.const_defined?("RailsAdmin")
  require 'rails_admin/adapters/mongoid'

  module RailsAdmin
    module Adapters
      module Mongoid
        alias_method :type_lookup_without_mongoid_snappy, :type_lookup
        def type_lookup(name, field)
          if field.type.to_s == 'Mongoid::Snappy'
            { :type => :text }
          else
            type_lookup_without_mongoid_snappy(name, field)
          end
        end
      end
    end
  end
end