# frozen_string_literal: true

require 'active_support/core_ext/string/inflections'

require_relative 'condition/function'
require_relative 'condition/operator'
require_relative 'condition/container'

module AhrefsApi
  module Condition
    def where(*args)
      where_conditions.push(build_condition(*args))
      self
    end

    def having(*args)
      having_conditions.push(build_condition(*args))
      self
    end

    def build_condition(*args)
      type =
        if AhrefsApi::Condition::Operator::OPERATORS.include?(args[1])
          AhrefsApi::Condition::Operator.type
        elsif AhrefsApi::Condition::Function::FUNCTIONS.include?(args[0])
          AhrefsApi::Condition::Function.type
        end
      "AhrefsApi::Condition::#{type.to_s.camelize}".constantize.factory(*args)
    end

    def where_conditions
      @where_conditions ||= AhrefsApi::Condition::Container.new
    end

    def having_conditions
      @having_conditions ||= AhrefsApi::Condition::Container.new
    end
  end
end
