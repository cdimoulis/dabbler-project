require "rails_helper"

RSpec.describe Blog::V1::TopicsController do
  include RequestSpecHelper

  # Test nested creates
  context '#create' do

    let!(:user) { create(:user) }

    before do
      full_sign_in user, '12345678'
    end

    after do
      full_sign_out
    end

    it "succeeds via groups" do

    end

    it "succeeds via published_groups" do

    end

    it "succeeds via tutorial_groups" do

    end
  end

  # test nested index
  context '#index' do

    it "fetches via domain" do

    end

    it "fetches via group" do

    end

    it "fetches via published_group" do

    end

    it "fetches via tutorial_group" do

    end
  end
end
