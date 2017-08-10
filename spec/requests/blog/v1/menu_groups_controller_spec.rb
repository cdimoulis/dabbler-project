require "rails_helper"

RSpec.describe Blog::V1::MenuGroupsController do
  include RequestSpecHelper

  # context '#create' do
  #   let!(:user) { create(:user) }
  #
  #   before do
  #     full_sign_in user, '12345678'
  #   end
  #
  #   after do
  #     full_sign_out
  #   end
  #
  #   it "succeeds via menu" do
  #
  #   end
  # end

  # test nested index
  context '#index' do
    # it "fetches via menu" do
    #   menu = create(:menu)
    #   menu_b = create(:menu)
    #   group_a = create(:menu_group, domain: menu.domain)
    #   group_b = create(:menu_group, domain: menu.domain)
    #   group_c = create(:menu_group, domain: menu.domain)
    #   group_d = create(:menu_group, domain: menu_b.domain)
    #   menu.menu_groups = [group_a, group_b, group_c]
    #   menu_b.menu_groups = [group_d]
    #   url = blog_v1_menu_menu_groups_path(menu_id: menu.id)
    #   get url, format: :json
    #   expect(response).to have_http_status(:success)
    #   expect(assigns(:records).count).to eq(3)
    # end

    it "fetches via domain" do
      domain = create(:domain_with_menu_groups)
      # create one more MenuGroup to add more than 5 from :domain_with_menu_groups
      menu_group = create(:menu_group)
      get blog_v1_domain_menu_groups_path(domain_id: domain.id), format: :json
      expect(response).to have_http_status(:success)
      # :domain_with_menu_groups factory creates 5 groups on default
      expect(assigns(:records).count).to eq(5)
    end

    # it "fetches via published_entry" do
    #   published_entry = create(:published_entry)
    #   group_a = create(:menu_group, domain: published_entry.domain)
    #   group_b = create(:menu_group, domain: published_entry.domain)
    #   group_c = create(:tutorial_group, domain: published_entry.domain)
    #   published_entry.menu_groups << group_b
    #   published_entry.menu_groups << group_c
    #   route = blog_v1_published_entry_menu_groups_path(published_entry_id: published_entry.id)
    #   get route, format: :json
    #   order = [group_b.id, group_c.id]
    #   expect(assigns(:records).pluck('id')).to match(order)
    # end
  end

  # context '#single_index' do
  #   it 'fetches via topic' do
  #     menu_group = create(:menu_group)
  #     topic = create(:topic, menu_group: menu_group, domain: menu_group.domain)
  #     get blog_v1_topic_menu_group_path(topic_id: topic.id), format: :json
  #     expect(assigns(:record)).to eq(group)
  #   end
  # end

  # Valid child ordering attribute
  context "VALID_CHILD_ORDERING_ATTRIBUTES" do
    let!(:menu_group) { create(:menu_group) }

    it "get correct values" do
      get blog_v1_menu_group_child_orderings_path(menu_group_id: menu_group.id), format: :json
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to eq(MenuGroup.VALID_CHILD_ORDERING_ATTRIBUTES)
    end
  end
end
