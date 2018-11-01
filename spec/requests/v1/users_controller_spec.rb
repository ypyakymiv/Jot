require 'rails_helper'

describe V1::UsersController do
  before :each do
    3.times do
      create :event
      create :user
    end
  end

  context 'GET /v1/users/' do
    it 'is successful when signed in' do
      get v1_users_path, headers: sign_in(User.first, "ferrari458")
      expect(response).to have_http_status(200)
    end
  end

  context 'GET /v1/users/:id' do
    it 'is successful when signed in' do
      get v1_user_path(User.second), headers: sign_in(User.first, "ferrari458")
      expect(response).to have_http_status(200)
    end
  end

  context 'POST /v1/users/' do

  end

  context 'PATCH /v1/users/:id' do

  end

  context 'DELETE /v1/users/:id' do

  end

end
