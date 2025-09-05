## Unreleased

## 0.3.0 - 2025-09-05

- Allow passing an ActiveStorage blob/attachment/preview/variant to the usual tag helpers:

  ```
  image_tag(blog_post.hero_image.variant(:medium))

  video_tag(product.intro_video)
  ```

## 0.2.0 - 2025-08-21

- ActiveStorage integration.

## 0.1.0 - 2025-08-10

- Initial release extracted from Parklife 0.7.0.
