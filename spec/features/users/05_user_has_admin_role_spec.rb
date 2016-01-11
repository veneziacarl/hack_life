require "rails_helper"

describe "#admin?" do
  it "is not an admin if the role is not admin" do
    user = FactoryGirl.create(:user, role: "member")
    expect(user.admin?).to eq(false)
  end

  it "is an admin if the role is admin" do
    user = FactoryGirl.create(:user, role: "admin")
    expect(user.admin?).to eq(true)
  end
end
