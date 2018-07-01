require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to have_many(:wikis) }

  describe "attributes" do

    it "should have name and email attributes" do
      expect(user).to have_attributes(name: user.name, email: user.email)
    end
  end
end
