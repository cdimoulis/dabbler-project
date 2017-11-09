require "rails_helper"

RSpec.describe Blog::V1::MenusController do
  include RequestSpecHelper

  context '#create' do
    let!(:admin) { create(:user) }
    let!(:menu) { attributes_for(:menu, domain: nil) }

    before do
      full_sign_in admin, '12345678'
    end

    after do
      full_sign_out
    end

    it 'creates via domain' do
      domain = create(:domain)
      post blog_v1_domain_menus_path(domain_id: domain.id), menu: menu, format: :json
      expect(response).to have_http_status(:success)
      expect(domain.menus.count).to eq(1)
      expect(assigns(:record).domain_id).to eq(domain.id)
    end
  end

  # test nested index
  context '#index' do
    context 'fetches via domain' do
      let!(:domain) { create(:domain) }

      context 'has ordering concern' do
        let!(:a) { create(:menu, domain: domain, text: 'A', order: nil) }
        let!(:b) { create(:menu, domain: domain, text: 'B', order: nil) }
        let!(:c) { create(:menu, domain: domain, text: 'C', order: 3) }
        let!(:d) { create(:menu, domain: domain, text: 'D', order: 2) }
        let!(:e) { create(:menu, domain: domain, text: 'E', order: 1) }
        let!(:f) { create(:menu, domain: domain, text: 'F', order: nil) }

        it 'orders correctly with default' do
          url = blog_v1_domain_menus_path(domain_id: domain.id)
          get url, format: :json
          ordered = [e,d,c,a,b,f]
          expect(assigns(:records).to_a).to match(ordered)
        end

        it 'orders correctly with text first' do
          domain.update_attribute(:menu_ordering, ['text:asc','order:asc'])
          f.update_attribute(:order, 4)
          b.update_attribute(:order, 5)
          a.update_attribute(:order, 6)
          url = blog_v1_domain_menus_path(domain_id: domain.id)
          get url, format: :json
          ordered = [a,b,c,d,e,f]
          expect(assigns(:records).to_a).to match(ordered)
        end
      end
    end
  end

  context '#single_index' do
    let!(:menu) { create(:menu) }

    it 'returns correct menu for menu_group' do
      menu_group = create(:menu_group, menu: menu)
      get blog_v1_menu_group_menu_path(menu_group_id: menu_group.id), format: :json
      expect(assigns(:record)).to eq(menu)
    end

    it 'returns correct menu for topic' do
      topic = create(:topic_with_menu, menu: menu)
      get blog_v1_topic_menu_path(topic_id: topic.id), format: :json
      expect(assigns(:record)).to eq(menu)
    end

    # it 'returns correct menu for published_entry' do
    #   published_entry = create(:published_entry, domain: domain)
    #   get blog_v1_published_entry_domain_path(published_entry_id: published_entry.id), format: :json
    #   expect(assigns(:record)).to eq(domain)
    # end
    #
    # it 'returns correct menu for featured_entry' do
    #   featured_entry = create(:featured_entry, domain: domain)
    #   get blog_v1_featured_entry_domain_path(featured_entry_id: featured_entry.id), format: :json
    #   expect(assigns(:record)).to eq(domain)
    # end
  end

  # Valid child ordering attribute
  context "VALID_CHILD_ORDERING_ATTRIBUTES" do
    let!(:menu) { create(:menu) }

    it "get correct values" do
      get blog_v1_menu_child_orderings_path(menu_id: menu.id), format: :json
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to eq(Menu.VALID_CHILD_ORDERING_ATTRIBUTES)
    end
  end
end
