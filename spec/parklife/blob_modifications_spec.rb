require 'rails_helper'

RSpec.describe Parklife::Rails::BlobModifications do
  context 'when the same file/filename is attached' do
    it 'the same key is assigned' do
      post = FactoryBot.create(:post)
      post.hero.attach(
        filename: 'plasma.jpg',
        io: file_fixture('plasma.jpg').open,
      )

      id1 = post.hero.blob.id
      key1 = post.hero.blob.key

      post.hero.purge
      post.hero.attach(
        filename: 'plasma.jpg',
        io: file_fixture('plasma.jpg').open,
      )

      id2 = post.hero.blob.id
      key2 = post.hero.blob.key

      expect(id2).not_to eql(id1)
      expect(key2).to eql(key1)
    end
  end

  context 'when the same file with a different filename is attached' do
    it 'a different key is assigned' do
      post1 = FactoryBot.create(:post)
      post1.hero.attach(
        filename: 'foo.jpg',
        io: file_fixture('plasma.jpg').open,
      )

      post2 = FactoryBot.create(:post)
      post2.hero.attach(
        filename: 'bar.jpg',
        io: file_fixture('plasma.jpg').open,
      )

      key1 = post1.hero.blob.key
      key2 = post2.hero.blob.key

      expect(key1).not_to eql(key2)
    end
  end

  context 'when a duplicate file/filename is attached' do
    it 'a different key is assigned' do
      post1 = FactoryBot.create(:post)
      post1.hero.attach(
        filename: 'plasma.jpg',
        io: file_fixture('plasma.jpg').open,
      )

      post2 = FactoryBot.create(:post)
      post2.hero.attach(
        filename: 'plasma.jpg',
        io: file_fixture('plasma.jpg').open,
      )

      key1 = post1.hero.blob.key
      key2 = post2.hero.blob.key

      expect(key1).not_to eql(key2)

      post1.hero.purge
      post2.hero.purge

      post1.hero.attach(
        filename: 'plasma.jpg',
        io: file_fixture('plasma.jpg').open,
      )
      post2.hero.attach(
        filename: 'plasma.jpg',
        io: file_fixture('plasma.jpg').open,
      )

      key3 = post1.hero.blob.key
      key4 = post2.hero.blob.key

      expect(key3).to eql(key1)
      expect(key4).to eql(key2)
    end
  end
end
