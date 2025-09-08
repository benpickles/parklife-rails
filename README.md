# Parklife::Rails

[![Ruby](https://github.com/benpickles/parklife-rails/actions/workflows/main.yml/badge.svg)](https://github.com/benpickles/parklife-rails/actions/workflows/main.yml)

A Rails app is a Rack app and as such things Just Work™, Parklife's Rails integration includes a few enhancements to make life easier and provides ActiveStorage integration so you can continue using the knowledge and tools you already have.

## Getting started

Add the gem to your application's `Gemfile`:

```bash
gem 'parklife-rails'
```

Parklife is configured with a file called `Parkfile` in the root of your project, here's an example `Parkfile` for an imaginary Rails app:

```ruby
# Load your application, this activates the Parklife/Rails integration and gives
# you access to route helpers and models in this file.
require_relative 'config/environment'

Parkfile.application.routes do
  # Start from the homepage and crawl all links.
  root crawl: true

  # Some extra paths that aren't discovered while crawling.
  get feed_path(format: :atom)
  get sitemap_path(format: :xml)

  # A couple more hidden pages.
  get easter_egg_path, crawl: true

  # Services typically allow a custom 404 page.
  get '/404.html'
end
```

Listing the routes included in the above Parklife application with `parklife routes` would output the following:

```
$ bundle exec parklife routes
/             crawl=true
/feed.atom
/sitemap.xml
/easter_egg   crawl=true
/404.html
```

Now you can run `parklife build` which will fetch all the routes and save them to the `build` directory ready to be served as a static site. Inspecting the build directory might look like this:

```
$ find build -type f
build/404.html
build/about/index.html
build/blog/2019/03/07/developers-developers-developers/index.html
build/blog/2019/04/21/modern-life-is-rubbish/index.html
build/blog/2019/05/15/introducing-parklife/index.html
build/blog/index.html
build/easter_egg/index.html
build/easter_egg/surprise/index.html
build/feed.atom
build/index.html
build/location/index.html
build/sitemap.xml
```

Parklife doesn't know about assets (images, CSS, etc) so you likely also need to generate those and copy them to the build directory, see the [example app's full build script](example-app/bin/static-build) for how you might do this.

## ActiveStorage integration

Parklife's ActiveStorage integration allows you to use ActiveStorage as normal in development, then during a Parklife build any encountered attachments are collected and copied to the build directory so they can be served alongside the rest of your static files. This is achieved via a Rails Engine and custom ActiveStorage DiskService which work together to tweak ActiveStorage URLs so they're suitable for a static web server.

Enable the engine in `config/application.rb`:

> [!NOTE]
> This must be done before the app boots so can't be in an initializer.

```ruby
require 'parklife-rails/activestorage'
```

Then switch to Parklife's ActiveStorage service in `config/storage.yml`:

```yml
local:
  service: Parklife
  root: <%= Rails.root.join("storage") %>
```

Finally, use ActiveStorage (almost entirely) as usual:

```ruby
# Pass a blob/attachment/preview/variant directly to helpers as usual:
image_tag(blog_post.hero_image.variant(:medium))
# => <img src="/parklife/blobs/6adews39uehd44spynetigykwssh/cute-cat.jpg" />
video_tag(product.intro_video)
# => <video src="/parklife/blobs/x74tu8izjv141l8503gwkkruokca/cat-mug.mp4"></video>

# Ask a variant for its path:
blog_post.hero_image.variant(:medium).processed.url
# => "/parklife/blobs/6adews39uehd44spynetigykwssh/cute-cat.jpg"

# Use the route helper:
Rails.application.routes.url_helpers.parklife_blob_path(
  blog_post.hero_image.variant(:medium)
)
# => "/parklife/blobs/6adews39uehd44spynetigykwssh/cute-cat.jpg"
```

The only quirk is if you want to generate the full URL (including hostname etc), in that case `parklife_blob_url` doesn't behave as you'd expect and you must also pass `only_path: false`:

```ruby
Rails.application.routes.url_helpers.parklife_blob_url(
  blog_post.hero_image.variant(:medium),
  only_path: false,
)
# => "http://example.com/parklife/blobs/6adews39uehd44spynetigykwssh/cute-cat.jpg"
```

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/benpickles/parklife-rails>. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/benpickles/parklife-rails/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Parklife::Rails project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/benpickles/parklife-rails/blob/main/CODE_OF_CONDUCT.md).
