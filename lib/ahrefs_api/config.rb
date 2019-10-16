# frozen_string_literal: true

module AhrefsApi
  module Config
    extend self

    VALID_CONFIG_KEYS = {
      token: '',
      timeout: 30
    }

    attr_accessor(* VALID_CONFIG_KEYS.keys)

    def reset
      VALID_CONFIG_KEYS.each do |k, v|
        send((k.to_s + '='), v)
      end
    end

    reset
  end

  class << self
    def configure
      block_given? ? yield(Config) : Config
    end

    def config
      Config
    end
  end
end
