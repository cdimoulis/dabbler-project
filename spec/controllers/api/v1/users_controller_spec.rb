require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do

  context 'test' do
    it 'works' do
      post :create, format: :json
    end
  end
end
