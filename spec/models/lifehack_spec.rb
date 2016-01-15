require 'rails_helper'

RSpec.describe Lifehack, type: :model do
  let! (:hack1) { FactoryGirl.create(:lifehack) }
  let! (:hack2) { FactoryGirl.create(:lifehack) }
  it { should have_valid(:title).when('newHack', 'another Hack') }
  it { should_not have_valid(:title).when(nil, '') }

  it { should have_valid(:description).when('long descr 92342', 'shortdesc') }
  it { should have_valid(:description).when(nil, '') }

  it 'shortens its description' do
    hack = Lifehack.new(
      title: 'test',
      description: %(this is a long!
        description to see if the shortening works.
        I really hope it does.
        And I hope to not get any hound violations.
        But I probably will.
      )
    )
    hack.short_description
    expect(hack.short_description.length).to eq(80)
  end

  it 'searches for all matching titles or descriptions, case insensitive' do
    search_result = Lifehack.search_all('TiE')
    expect(search_result.length).to eq(2)

    search_result = Lifehack.search_all(hack1.description.split('').pop)
    expect(search_result.length).to eq(1)

    search_result = Lifehack.search_all('kNOt')
    expect(search_result.length).to eq(2)
  end

  it 'searches for matching title attribute, case insensitive' do
    search_result = Lifehack.search_title('tIE')
    expect(search_result.length).to eq(2)

    search_result = Lifehack.search_title(hack1.description.split('').pop)
    expect(search_result.length).to eq(1)
  end

  it 'searches for matching description attribute, case insensitive' do
    search_result = Lifehack.search_description('KnOT')
    expect(search_result.length).to eq(2)

    search_result = Lifehack.search_description(hack1.description.split('').pop)
    expect(search_result.length).to eq(1)
  end

  it 'searches for matching user attribute by first, last, full name' do
    search_result = Lifehack.search_user('JoHn')
    expect(search_result.length).to eq(2)

    search_result = Lifehack.search_user('laSt')
    expect(search_result.length).to eq(2)

    search_result = Lifehack.search_user('johN las')
    expect(search_result.length).to eq(2)
  end

  it 'averages review ratings above 0 and rounds to 2 digits' do
    FactoryGirl.create(:review, lifehack: hack1, rating: 3)
    FactoryGirl.create(:review, lifehack: hack1, rating: 4)

    expect(hack1.reviews.count).to eq(2)
    expect(hack1.avg_review_rating).to eq("3.50")
    expect(hack2.reviews.count).to eq(0)
    expect(hack2.avg_review_rating).to eq("0.00")
  end
end
