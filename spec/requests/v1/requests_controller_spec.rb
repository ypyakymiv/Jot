require 'rails_helper'

describe V1::RequestsController do
  before :each do
    3.times do
      create :user
    end

    User.first.friend_request User.second
    User.second.accept_request User.first
  end

  context 'GET /v1/requests' do
    it 'displays all requests' do
      User.first.friend_request User.third
      get v1_requests_path, headers: sign_in(User.third, 'ferrari458')
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).count).to eq(1)
      get v1_requests_path, headers: sign_in(User.first, 'ferrari458')
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).count).to eq(0)
    end
  end

  context 'GET /v1/pending' do
    it 'displays all pending' do
      User.first.friend_request User.third
      get v1_pending_path, headers: sign_in(User.first, 'ferrari458')
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).count).to eq(1)
      get v1_pending_path, headers: sign_in(User.third, 'ferrari458')
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).count).to eq(0)
    end
  end

  context 'POST /v1/users/:user_id/request' do
    it 'accepts a request' do
      User.first.friend_request User.third
      pending_count = User.first.pending_friends.count
      friends_count = User.third.friends.count
      requested_count = User.third.requested_friends.count
      post v1_user_request_path(User.first), headers: sign_in(User.third, 'ferrari458')
      expect(response).to have_http_status(204)
      expect(pending_count - 1).to eq(User.first.pending_friends.count)
      expect(friends_count + 1).to eq(User.third.friends.count)
      expect(requested_count - 1).to eq(User.third.requested_friends.count)
    end
  end

  context 'DELETE /v1/users/:user_id/request' do
    it 'allows passive to reject' do
      User.first.friend_request User.third
      pending_count = User.first.pending_friends.count
      friends_count = User.third.friends.count
      requested_count = User.third.requested_friends.count
      delete v1_user_request_path(User.first), headers: sign_in(User.third, 'ferrari458')
      expect(response).to have_http_status(204)
      expect(pending_count - 1).to eq(User.first.pending_friends.count)
      expect(friends_count).to eq(User.third.friends.count)
      expect(requested_count - 1).to eq(User.third.requested_friends.count)
    end

    it 'allows active to reject' do
      User.first.friend_request User.third
      pending_count = User.first.pending_friends.count
      friends_count = User.third.friends.count
      requested_count = User.third.requested_friends.count
      delete v1_user_request_path(User.third), headers: sign_in(User.first, 'ferrari458')
      expect(response).to have_http_status(204)
      expect(pending_count - 1).to eq(User.first.pending_friends.count)
      expect(friends_count).to eq(User.third.friends.count)
      expect(requested_count - 1).to eq(User.third.requested_friends.count)
    end
  end

end
