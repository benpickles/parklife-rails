plasma_path = File.expand_path('../../spec/fixtures/files/plasma.jpg', __dir__)

Rails.root.join('data').children.each_with_index do |path, i|
  id, slug = path.basename('.*').to_s.split('-', 2)
  title, rest = path.read.split("\n", 2)

  post = Post.find_or_initialize_by(id: id)
  post.body = rest
  post.slug = slug
  post.title = title
  post.save!

  post.hero.attach(
    filename: 'plasma.jpg',
    io: File.open(plasma_path),
  ) if i.odd?
end
