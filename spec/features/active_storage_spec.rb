require 'rails_helper'

RSpec.describe 'ActiveStorage integration' do
  context 'with the Parklife service' do
    let!(:post1) { FactoryBot.create(:post) }
    let!(:post2) { FactoryBot.create(:post) }

    before do
      post1.hero.attach(
        filename: 'plasma.jpg',
        io: file_fixture('plasma.jpg').open,
      )
    end

    it "works as normal and uses Parklife's blob controller" do
      visit root_path
      click_link post2.title

      expect(page).not_to have_css('img')

      click_link 'Home'
      click_link post1.title

      expect(page).to have_css('img')

      img = find('img')
      expect(img[:src]).to start_with('/parklife/')
    end
  end
end
