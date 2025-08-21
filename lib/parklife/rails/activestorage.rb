# frozen_string_literal: true
module Parklife
  module Rails
    module ActiveStorage
      Asset = Struct.new(:service, :key, :url) do
        def blob_path
          service.path_for(key)
        end
      end

      class Engine < ::Rails::Engine
        isolate_namespace Parklife::Rails::ActiveStorage

        initializer 'parklife.app_integration' do |app|
          # Disable the standard ActiveStorage routes that will otherwise
          # prevent a blob being served by Parklife's controller.
          app.config.active_storage.draw_routes = false
        end
      end

      mattr_accessor :collect_assets, default: false
      mattr_accessor :collected_assets, default: {}
      mattr_accessor :routes_prefix, default: 'parklife'

      def self.collect_asset(service, key, url)
        collected_assets[key] ||= Asset.new(service, key, url)
      end
    end
  end
end
