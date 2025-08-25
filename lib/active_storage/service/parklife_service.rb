# frozen_string_literal: true
require 'active_storage/service/disk_service'

module ActiveStorage
  class Service::ParklifeService < Service::DiskService
    def url(key, **options)
      super.tap do |path|
        if Parklife::Rails::ActiveStorage.collect_assets
          Parklife::Rails::ActiveStorage.collect_asset(self, key, path)
        end
      end
    end

    private
      def generate_url(key, expires_in:, filename:, content_type:, disposition:) # rubocop:disable Lint/UnusedMethodArgument
        url_helpers.parklife_blob_service_path(key: key, filename: filename)
      end
  end
end
