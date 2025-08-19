# frozen_string_literal: true
require 'fileutils'
require 'parklife'
require 'rails'
require_relative 'config_refinements'
require_relative 'route_set_refinements'

module Parklife
  module Rails
    class BuildIntegration < ::Rails::Railtie
      initializer 'parklife.build_integration' do |app|
        # The offending middleware is included in Rails (6+) development mode and
        # rejects a request with a 403 response if its host isn't present in the
        # allowlist (a security feature). This prevents Parklife from working in
        # a Rails app out of the box unless you manually add the expected
        # Parklife base to the hosts allowlist or set it to nil to disable it -
        # both of which aren't great because they disable the security feature
        # whenever the development server is booted.
        #
        # https://guides.rubyonrails.org/configuring.html#actiondispatch-hostauthorization
        #
        # However it's safe to remove the middleware at this point because it
        # won't be executed in the normal Rails development flow, only via a
        # Parkfile when parklife/rails is required.
        if defined?(ActionDispatch::HostAuthorization)
          app.middleware.delete(ActionDispatch::HostAuthorization)
        end

        Parklife.application.config.app = app

        # This ensures next tweak is compatibile with Rails 8+ lazy routes.
        Parklife.application.routes.extend(RouteSetRefinements)

        # Allow use of the Rails application's route helpers when defining
        # Parklife routes in the block form.
        Parklife.application.routes.singleton_class.include(app.routes.url_helpers)

        Parklife.application.config.extend(ConfigRefinements)
      end

      config.after_initialize do |app|
        # Read the Rails app's URL config and apply it to Parklife's so that the
        # Rails config can be used as the single source of truth.
        host, port, protocol = app.default_url_options.values_at(:host, :port, :protocol)
        protocol = 'https' if app.config.force_ssl
        path = ActionController::Base.relative_url_root

        Parklife.application.config.base.scheme = protocol if protocol
        Parklife.application.config.base.host = host if host
        Parklife.application.config.base.port = port if port
        Parklife.application.config.base.path = path if path

        # If the host Rails app includes Parklife's ActiveStorage integration
        # then automatically collect attachments encountered during a build and
        # copy them to the build directory.
        if defined?(Parklife::Rails::ActiveStorage)
          Parklife.application.before_build do
            ActiveStorage.collected_assets.clear
            ActiveStorage.collect_assets = true
          end

          Parklife.application.after_build do
            ActiveStorage.collected_assets.each_value do |asset|
              build_path = File.join(Parklife.application.config.build_dir, asset.url)
              FileUtils.mkdir_p(File.dirname(build_path))
              FileUtils.cp(asset.blob_path, build_path)
            end
          end
        end
      end
    end
  end
end
