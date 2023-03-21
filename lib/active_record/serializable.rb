require 'active_record'
require 'active_support/core_ext/marshal'
require 'rasti-model'

require_relative 'serializable/version'

module ActiveRecord
  module Serializable

    class << self

      def create_for(active_record_class)
        const_name = const_name_for active_record_class

        return const_get const_name if const_defined? const_name

        attribute_names = active_record_class.attribute_names.map(&:to_sym)

        Rasti::Model[*attribute_names].tap do |serializable_class|
          serializable_class.instance_eval do
            active_record_class.reflections.each do |name, relation|
              cast_method_name = "cast_#{name}".to_sym
              attribute name.to_sym, cast_method_name

              define_method cast_method_name do |value|
                base_type = Rasti::Types::Model[relation.klass.serializable_class]
                type = relation.collection? ? Rasti::Types::Array[base_type] : base_type
                type.cast value
              end

              private cast_method_name
            end

            active_record_class.serializable_included_modules.each do |mod|
              include mod
            end

            active_record_class.serializable_defined_methods.each do |name, block|
              define_method(name, &block)
            end
          end

          const_set const_name, serializable_class
        end
      end

      def const_missing(const_name)
        active_record_class_name = active_record_class_name_for const_name
        if Object.const_defined? active_record_class_name
          Object.const_get(active_record_class_name).serializable_class
        else
          super const_name
        end
      end

      private

      def const_name_for(active_record_class)
        Inflecto.underscore(active_record_class.name).gsub('/', '__').upcase
      end

      def active_record_class_name_for(const_name)
        Inflecto.camelize(const_name.to_s.downcase.gsub('__', '/'))
      end

    end

    module ClassMethods

      def serializable_class
        @serializable_class ||= Serializable.create_for self
      end

      def serializable_included_modules
        @serializable_included_modules ||= Set.new
      end

      def serializable_include(*modules)
        modules.each { |m| serializable_included_modules << m }
      end

      def serializable_defined_methods
        @serializable_defined_methods ||= {}
      end

      def serializable_define_method(name, &block)
        serializable_defined_methods[name] = block
      end

    end

    module InstanceMethods

      def to_serializable(*args)
        hash = as_json(*args)
        self.class.serializable_class.new hash
      end

    end

  end

  Base.instance_eval do
    extend Serializable::ClassMethods
    include Serializable::InstanceMethods
  end

end