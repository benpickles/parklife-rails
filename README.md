# Parklife::Rails

## Installation

Add the gem to your application's `Gemfile`:

```bash
gem 'parklife-rails'
```

## ActiveStorage integration

Parklife's ActiveStorage integration allows you to use ActiveStorage as normal in development, then during a Parklife build any encountered attachments are collected and copied to the build directory so they can be served alongside the rest of your static files. This is achieved via a Rails Engine and custom ActiveStorage DiskService which work together to tweak ActiveStorage URLs so they're suitable for a static web server.

Enable the engine at the bottom of `config/application.rb`:

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

Finally anywhere an attachment is referenced make sure to use the `processed` URL:

```ruby
image_tag(
  blog_post.hero_image.representation(:medium).processed.url
)
```

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/benpickles/parklife-rails>. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/benpickles/parklife-rails/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Parklife::Rails project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/benpickles/parklife-rails/blob/main/CODE_OF_CONDUCT.md).
