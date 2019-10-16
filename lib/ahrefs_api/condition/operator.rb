# frozen_string_literal: true

module AhrefsApi
  module Condition
    class Operator
      OPERATORS = ['=', '<>', '<', '<=', '>', '>=']

      class << self
        def type
          :operator
        end

        def factory(*args)
          new(args[0], args[1], args[2])
        end
      end

      attr_reader :column, :operator, :value

      def initialize(column, operator, value)
        @column = column
        @operator = operator
        @value = value
      end

      def to_s
        %{#{column}#{operator}"#{value}"}
      end

      def ==(other)
        column == other.column && operator == other.operator
      end
    end
  end
end
