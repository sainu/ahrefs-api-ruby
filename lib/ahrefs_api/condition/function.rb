# frozen_string_literal: true

module AhrefsApi
  module Condition
    class Function
      FUNCTIONS = ['subdomain', 'substring', 'word']

      class << self
        def type
          :function
        end

        def factory(*args)
          send(args[0], args[1], args[2])
        end

        def subdomain(column, domain)
          new('subdomain', column, domain)
        end

        def substring(column, value)
          new('substring', column, value)
        end

        def word(column, data)
          new('word', column, data)
        end
      end

      attr_reader :function, :column, :value

      def initialize(function, column, value)
        @function = function
        @column = column
        @value = value
      end

      def to_s
        %{#{function}(#{column},"#{value}")}
      end

      def ==(other)
        function == other.function && column == other.column
      end
    end
  end
end
