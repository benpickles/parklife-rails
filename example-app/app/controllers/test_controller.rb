class TestController < ApplicationController
  layout false

  def activestorage
    @post1 = Post.find(1)
    @post3 = Post.find(3)
  end

  def middleware
    render plain: Rails.application.config.middleware.map(&:name).join("\n")
  end

  def url
    render plain: test_url_url
  end
end
