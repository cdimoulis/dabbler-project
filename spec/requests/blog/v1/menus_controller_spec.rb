require "rails_helper"

RSpec.describe Blog::V1::MenusController do
  include RequestSpecHelper

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

end
