require 'rails_helper'

RSpec.describe Lifehack, type: :model do
  it { should have_valid(:title).when('newHack', 'another Hack') }
  it { should_not have_valid(:title).when(nil, '') }

  it { should have_valid(:description).when('long descr 92342', 'shortdesc') }
  it { should have_valid(:description).when(nil, '') }
end
