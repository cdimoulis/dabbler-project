require "rails_helper"

RSpec.describe Blog::V1::MenuGroupsController do
  include RequestSpecHelper

  # test nested index
  context '#index' do

    it "fetches via menu" do
      menu = create(:menu)
      menu_b = create(:menu)
      group_a = create(:menu_group, domain: menu.domain)
      group_b = create(:menu_group, domain: menu.domain)
      group_c = create(:menu_group, domain: menu.domain)
      group_d = create(:menu_group, domain: menu_b.domain)
      menu.menu_groups = [group_a, group_b, group_c]
      menu_b.menu_groups = [group_d]
      url = blog_v1_menu_menu_groups_path(menu_id: menu.id)
      get url, format: :json
      expect(response).to have_http_status(:success)
      expect(assigns(:records).count).to eq(3)
    end
  end

end
