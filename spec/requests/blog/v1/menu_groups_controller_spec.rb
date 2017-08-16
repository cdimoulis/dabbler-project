require "rails_helper"

RSpec.describe Blog::V1::MenuGroupsController do
  include RequestSpecHelper

  context '#create' do
    let!(:admin) { create(:user) }
    let!(:menu_group) { attributes_for(:menu_group, menu: nil) }

    before do
      full_sign_in admin, '12345678'
    end

    after do
      full_sign_out
    end

    it "creates via menu" do
      menu = create(:menu)
      post blog_v1_menu_menu_groups_path(menu_id: menu.id), menu_group: menu_group, format: :json
      expect(response).to have_http_status(:success)
      expect(menu.menu_groups.count).to eq(1)
      expect(assigns(:record).menu_id).to eq(menu.id)
    end
  end

  # test nested index
  context '#index' do
    context 'fetches via menu' do
      let!(:menu) { create(:menu) }

      context 'has ordering concern' do
        let!(:a) { create(:menu_group, menu: menu, text: 'A', order: nil) }
        let!(:b) { create(:menu_group, menu: menu, text: 'B', order: nil) }
        let!(:c) { create(:menu_group, menu: menu, text: 'C', order: 3) }
        let!(:d) { create(:menu_group, menu: menu, text: 'D', order: 2) }
        let!(:e) { create(:menu_group, menu: menu, text: 'E', order: 1) }
        let!(:f) { create(:menu_group, menu: menu, text: 'F', order: nil) }

        it 'orders correctly with default' do
          url = blog_v1_menu_menu_groups_path(menu_id: menu.id)
          get url, format: :json
          ordered = [e,d,c,a,b,f]
          expect(assigns(:records).to_a).to match(ordered)
        end

        it 'orders correctly with text first' do
          menu.update_attribute(:menu_group_ordering, ['text:asc','order:asc'])
          f.update_attribute(:order, 4)
          b.update_attribute(:order, 5)
          a.update_attribute(:order, 6)
          url = blog_v1_menu_menu_groups_path(menu_id: menu.id)
          get url, format: :json
          ordered = [a,b,c,d,e,f]
          expect(assigns(:records).to_a).to match(ordered)
        end
      end
    end

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
