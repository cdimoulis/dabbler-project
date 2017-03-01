require 'rails_helper'

RSpec.describe Blog::V1::MenusController, type: :controller do

    # tests for CREATE route
    context "#create" do
      before do
        sign_in
      end

      it 'errors - no data' do
        post :create
        expect(response).to have_http_status(422)
      end

      it 'succeeds' do
        current = Menu.count
        menu = attributes_for(:menu)
        post :create, menu: menu, format: :json
        expect(response).to have_http_status(:success)
        expect(Menu.count).to eq(current+1)
      end
    end

    # Tests for SHOW route
    context "#show" do

      let!(:menu) { create(:menu) }

      # Before running a test do this
      before do
        get :show, id: menu.id, format: :json
      end

      it { is_expected.to respond_with(:success) }

      it 'returns JSON' do
        # look_like_json found in support/matchers/json_matchers.rb
        expect(response.body).to look_like_json
      end

      it { expect(assigns(:record)).to eq(menu) }
    end
end
