image_path = File.expand_path('../../spec/fixtures/files/plasma.jpg', __dir__)
video_path = File.expand_path('../../spec/fixtures/files/plasma.mp4', __dir__)

Rails.root.join('data').children.each_with_index do |path, i|
  id, slug = path.basename('.*').to_s.split('-', 2)
  title, rest = path.read.split("\n", 2)

  post = Post.find_or_initialize_by(id: id)
  post.body = rest
  post.slug = slug
  post.title = title
  post.save!

  case id.to_i
  when 1
    post.hero.attach(
      filename: 'image1.jpg',
      io: File.open(image_path),
    )
  when 3
    post.hero.attach(
      filename: 'video3.mp4',
      io: File.open(video_path),
    )
  end
end
