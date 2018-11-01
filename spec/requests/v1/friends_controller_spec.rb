require 'rails_helper'

describe V1::FriendsController do
  before :each do
    3.times do
      create :user
    end

    User.first.friend_request User.second
    User.second.accept_request User.first
  end

  context 'GET /v1/friends' do
    it 'returns all the friends' do
      friend_count = User.first.friends.count
      get v1_friends_path, headers: sign_in(User.first, 'ferrari458')
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).count).to eq(friend_count)
      User.first.friend_request User.third
      User.third.accept_request User.first
      get v1_friends_path, headers: sign_in(User.first, 'ferrari458')
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).count).to eq(friend_count + 1)
    end
  end

  context 'POST /v1/users/:user_id/friend' do
    it 'adds to pending' do
      pending_count = User.first.pending_friends.count
      requested_count = User.third.requested_friends.count
      post v1_user_friend_path(User.third), headers: sign_in(User.first, 'ferrari458')
      expect(response).to have_http_status(204)
      expect(pending_count + 1).to eq(User.first.pending_friends.count)
      expect(requested_count + 1).to eq(User.third.requested_friends.count)
    end
  end

  context 'DELETE /v1/users/:user_id/friend' do
    it 'user 1 removes from friends' do
      friend_count = User.first.friends.count
      delete v1_user_friend_path(User.second), headers: sign_in(User.first, 'ferrari458')
      expect(response).to have_http_status(204)
      expect(friend_count - 1).to eq(User.first.friends.count)
    end

    it 'user 2 removes from friends' do
      friend_count = User.second.friends.count
      delete v1_user_friend_path(User.first), headers: sign_in(User.second, 'ferrari458')
      expect(response).to have_http_status(204)
      expect(friend_count - 1).to eq(User.second.friends.count)
    end

    it 'fails when a non friend is involved' do
      friend_count = User.first.friends.count
      User.first.friend_request User.second
      delete v1_user_friend_path(User.first), headers: sign_in(User.third, 'ferrari458')
      expect(friend_count).to eq(User.first.friends.count)
    end
  end
end
