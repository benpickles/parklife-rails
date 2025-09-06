# frozen_string_literal: true
module Parklife
  module Rails
    module BlobModifications
      def self.prepended(base)
        base.before_validation :set_parklife_key
      end

      # Generate a deterministic MD5 hash for the Blob.
      #
      # This means that for a completely fresh Parklife build the same file with
      # the same contents will be stored with the same filename so there's no
      # unnecessary cache busting between deployments.
      #
      # @return [String]
      def generate_parklife_key
        OpenSSL::Digest::MD5.hexdigest(
          [
            byte_size,
            checksum,
            content_type,
            filename,
            service_name,
          ].map(&:to_s).join
        )
      end

      # Override the standard setter so `has_secure_token :key` does nothing.
      def key=(_)
        nil
      end

      # Override the standard getter which otherwise assigns a random token.
      def key
        self[:key]
      end

      private
        def set_parklife_key
          self[:key] ||= generate_parklife_key
        end
    end
  end
end

ActiveSupport.on_load(:active_storage_blob) do
  ActiveStorage::Blob.prepend Parklife::Rails::BlobModifications
end
