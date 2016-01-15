require 'rails_helper'

RSpec.describe UserSeeder, type: :model do
  it 'creates a name' do
    expect(UserSeeder.fake_name.first).to be_a(String)
    expect(UserSeeder.fake_name.last).to be_a(String)
  end

  it 'create an email' do
    expect(UserSeeder.fake_email[0]).to be_a(String)
    expect(UserSeeder.fake_email[0].match(/(.+)@(.+)\.(\w+)/)).to_not be_nil
    expect(UserSeeder.fake_email[1].match(/(.+)$/)).to_not be_nil
    expect(UserSeeder.fake_email[2].match(/^@(.+)\.(\w+)/)).to_not be_nil
  end

  it 'creates a photo' do
    5.times do
      expect(UserSeeder.f_phot.match(/(dog|cat)\d\.jpeg/)).to_not be_nil
    end
  end
end
