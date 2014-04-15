# coding: utf-8

require 'mongoid_snappy/version'
require 'snappy'

module Mongoid
  class Snappy
    instance_methods.each { |m| undef_method m unless m =~ /(^__|^send$|^object_id$)/ }

    def initialize(data)
      @data = data.force_encoding('UTF-8')
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
      if defined?(Moped::BSON) && !defined?(BSON)
        Moped::BSON::Binary.new(:generic, ::Snappy.deflate(@data))
      else
        BSON::Binary.new(::Snappy.deflate(@data), :generic)
      end
    end

    protected

    def method_missing(name, *args, &block)
      @data.send(name, *args, &block)
    end

    class << self

      # Get the object as it was stored in the database, and instantiate
      # this custom class from it.
      def demongoize(object)
        if defined?(Moped::BSON) && object.is_a?(Moped::BSON::Binary)
          Mongoid::Snappy.new(::Snappy.inflate(object.data))
        elsif defined?(BSON) && object.is_a?(BSON::Binary)
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
  require "mongoid_snappy/rails_admin"
end