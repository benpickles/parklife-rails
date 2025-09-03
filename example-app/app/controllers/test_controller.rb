class TestController < ApplicationController
  layout false

  def middleware
    render plain: Rails.application.config.middleware.map(&:name).join("\n")
  end

  def url
    render plain: test_url_url
  end
end
