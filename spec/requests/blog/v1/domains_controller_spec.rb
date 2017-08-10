require 'rails_helper'

RSpec.describe Blog::V1::DomainsController do
  include RequestSpecHelper

  context '#single_index' do
    let!(:domain) { create(:domain) }

    it 'returns correct domain for menu' do
      menu = create(:menu, domain: domain)
      get blog_v1_menu_domain_path(menu_id: menu.id), format: :json
      expect(assigns(:record)).to eq(domain)
    end

    it 'returns correct domain for menu_group' do
      menu_group = create(:menu_group_with_domain, domain: domain)
      get blog_v1_menu_group_domain_path(menu_group_id: menu_group.id), format: :json
      expect(assigns(:record)).to eq(domain)
    end

    it 'returns correct domain for topic' do
      topic = create(:topic_with_domain, domain_id: domain.id)
      get blog_v1_topic_domain_path(topic_id: topic.id), format: :json
      expect(assigns(:record)).to eq(domain)
    end
    
    it 'returns correct domain for published_entry' do
      published_entry = create(:published_entry, domain: domain)
      get blog_v1_published_entry_domain_path(published_entry_id: published_entry.id), format: :json
      expect(assigns(:record)).to eq(domain)
    end

    # it 'returns correct domain for featured_entry' do
    #   featured_entry = create(:featured_entry, domain: domain)
    #   get blog_v1_featured_entry_domain_path(featured_entry_id: featured_entry.id), format: :json
    #   expect(assigns(:record)).to eq(domain)
    # end

  end

  # Valid child ordering attribute
  context "VALID_CHILD_ORDERING_ATTRIBUTES" do
    let!(:domain) { create(:domain) }

    it "get correct values" do
      get blog_v1_domain_child_orderings_path(domain_id: domain.id), format: :json
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to eq(Domain.VALID_CHILD_ORDERING_ATTRIBUTES)
    end
  end
end
