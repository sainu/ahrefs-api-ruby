# frozen_string_literal: true

require_relative 'response'
require_relative 'condition'

module AhrefsApi
  class Client
    include ActiveModel::Validations
    include ActiveModel::Attributes
    include AhrefsApi::Condition

    API_BASE_URL = 'https://apiv2.ahrefs.com'

    FROMS = %w[
      ahrefs_rank anchors anchors_refdomains
      backlinks backlinks_new_lost backlinks_new_lost_counters backlinks_one_per_domain broken_backlinks broken_links
      domain_rating
      linked_anchors linked_domains linked_domains_by_type
      metrics metrics_extended
      pages pages_extended pages_info
      refdomains refdomains_by_type refdomains_new_lost refdomains_new_lost_counters refips
      subscription_info
    ].freeze
    OUTPUTS = %w[json xml php].freeze
    MODES = %w[exact domain subdomains prefix].freeze
    MIN_LIMIT = 5

    attribute :token,     :string,    default: -> { AhrefsApi.config.token }
    attribute :from,      :string
    attribute :target,    :string
    attribute :output,    :string,    default: 'json'
    attribute :mode,      :string,    default: 'subdomains'
    attribute :limit,     :integer,   default: 25
    attribute :timeout,   :integer

    validates :token,   presence: true, length: { is: 40 }
    validates :from,    inclusion: { in: FROMS }
    validates :target,  presence: true
    validates :output,  inclusion: { in: OUTPUTS }
    validates :mode,    inclusion: { in: MODES }
    validates :limit,   numericality: { greater_than: MIN_LIMIT - 1 }
    validates :timeout, numericality: { greater_than: 0 }

    OUTPUTS.each do |output|
      define_method "output_#{output}" do
        self.output = output
        self
      end
    end

    MODES.each do |mode|
      define_method "mode_#{mode}" do
        self.mode = mode
        self
      end
    end

    FROMS.each do |from|
      define_method "from_#{from}" do
        self.from = from
        self
      end
    end

    def order(args)
      @order ||= {}
      case args
      when Symbol
        @order[args] = :asc
      when Hash
        @order.merge!(args)
      when String
        @order.merge!(args.split(',').map { |pair| pair.split(' ').map(&:to_sym) }.to_h)
      end
      self
    end

    def order_by
      @order&.map { |k, v| "#{k}:#{v}" }&.join(',')
    end

    def select(*args)
      @select ||= ""
      @select += args.map(&:to_s).join(',')
      self
    end

    def endpoint
      API_BASE_URL
    end

    def params
      params = {
        token: token,
        from: from,
        target: target,
        mode: mode,
        output: output,
        limit: limit
      }
      params[:order_by] = order_by unless order_by.nil?
      params[:where] = where_conditions.to_s unless where_conditions.empty?
      params[:having] = having_conditions.to_s unless having_conditions.empty?
      params[:select] = @select unless @select.nil? || @select.empty?
      params
    end

    def send_get
      return unless valid?

      send_request(:get, endpoint, params)
    end

    def timeout
      super || AhrefsApi.config.timeout
    end

    def valid?
      return true if ['subscription_info'].include?(from)

      super
    end

    private

    def send_request(method, path, params = nil, headers = nil)
      Response.new(api_connection.send(method, path, params, headers))
    end

    def api_connection
      @api_connection ||= Faraday.new(request: { timeout: timeout }) do |c|
        c.response :logger
        c.response :json
        c.adapter Faraday.default_adapter
      end
    end
  end
end
