require 'rails_helper'

RSpec.describe Lifehack, type: :model do
  it { should have_valid(:title).when('newHack', 'another Hack') }
  it { should_not have_valid(:title).when(nil, '') }

  it { should have_valid(:description).when('long descr 92342', 'shortdesc') }
  it { should have_valid(:description).when(nil, '') }

  it 'shortens its description' do
    hack = Lifehack.new(title: 'test', description: 'this is a long! description to see if the shortening works.')
    hack.short_description
    expect(hack.short_description.length).to eq(40)
    expect(hack.short_description).to eq('this is a long! description to see if th')
  end
end
