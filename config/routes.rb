# frozen_string_literal: true
Rails.application.routes.draw do
  scope Parklife::Rails::ActiveStorage.routes_prefix do
    get 'blobs/:key/*filename',
      to: 'parklife/rails/active_storage/blobs#show',
      as: :parklife_blob_service
  end

  direct :parklife_blob do |obj, options|
    blob = case obj
    when ActiveStorage::Attachment
      obj.blob
    when ActiveStorage::Preview, ActiveStorage::VariantWithRecord
      obj.processed.image.blob
    else
      obj
    end

    options = { only_path: true }.merge(options)
    url = route_for(:parklife_blob_service, blob.key, blob.filename, options)

    if Parklife::Rails::ActiveStorage.collect_assets
      service = ActiveStorage::Blob.services.fetch(blob.service_name)

      # When collecting ActiveStorage Blobs we only ever want the path and never
      # its full URL.
      path = if options[:only_path]
        url
      else
        route_for(
          :parklife_blob_service,
          blob.key,
          blob.filename,
          options.merge(only_path: true),
        )
      end

      Parklife::Rails::ActiveStorage.collect_asset(service, blob.key, path)
    end

    url
  end

  resolve('ActiveStorage::Attachment')        { |attachment, options| route_for(:parklife_blob, attachment, options) }
  resolve('ActiveStorage::Blob')              { |blob, options| route_for(:parklife_blob, blob, options) }
  resolve('ActiveStorage::Preview')           { |preview, options| route_for(:parklife_blob, preview, options) }
  resolve('ActiveStorage::VariantWithRecord') { |variant, options| route_for(:parklife_blob, variant, options) }
end
