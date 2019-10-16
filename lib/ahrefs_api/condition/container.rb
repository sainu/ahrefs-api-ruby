# frozen_string_literal: true

module AhrefsApi
  module Condition
    class Container < Array
      def to_s
        map(&:to_s).join(',')
      end
    end
  end
end
