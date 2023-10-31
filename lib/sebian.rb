# frozen_string_literal: true

require_relative 'sebian/version'
require 'f1sales_custom/parser'
require 'f1sales_custom/source'
require 'f1sales_custom/hooks'

module Sebian
  class Error < StandardError; end

  class F1SalesCustom::Hooks::Lead
    class << self
      def switch_source(lead)
        @lead = lead
        return "#{source_name} - #{separates_store_group}" if separates_store_group

        source_name
      end

      def switch_salesman(lead)
        @lead = lead
        { email: "#{emailize}@sebian.com.br" }
      end

      private

      def separates_store_group
        split_message.last
      end

      def source_name
        @lead.source.name
      end

      def split_message
        @lead.message.split(' - ')
      end

      def separates_store_address
        split_message[1] || ''
      end

      def emailize
        separates_store_address.dup.force_encoding('UTF-8').unicode_normalize(:nfkd)
                               .encode('ASCII', replace: '').downcase.gsub(/\W+/, '')
      end
    end
  end
end
