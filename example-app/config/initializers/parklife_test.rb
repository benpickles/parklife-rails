case ENV['PARKLIFE_SET_RAILS_URL']
when 'force_ssl'
  Rails.application.config.force_ssl = true
when 'yes'
  ActionController::Base.relative_url_root = '/foo'

  Rails.application.routes.default_url_options.merge!(
    host: 'rails.example.org',
    protocol: 'https',
  )
end
