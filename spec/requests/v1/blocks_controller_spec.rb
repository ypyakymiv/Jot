require 'rails_helper'

describe V1::BlocksController do

  before :each do
    2.times do
      create :user
    end

    User.first.friend_request User.second
    User.second.accept_request User.first
  end

  context 'GET /v1/blocks' do
    it 'shows no blocks at first' do
      get v1_blocks_path, headers: sign_in(User.first, 'ferrari458')
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).count).to eq(0)
    end

    it 'show blocks present' do
      User.first.block_friend User.second
      get v1_blocks_path, headers: sign_in(User.first, 'ferrari458')
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).count).to eq(1)
    end
  end

  # Later on write tests for what blocks do

  context 'POST /v1/users/:user_id/block' do
    it 'blocks users' do
      blocked_count = User.first.blocked_friends.count
      post v1_user_block_path(User.second), headers: sign_in(User.first, 'ferrari458')
      expect(response).to have_http_status(204)
      expect(blocked_count).to eq(User.first.blocked_friends.count - 1)
      expect(User.first.blocked_friends.include?(User.second))
    end
  end

  context 'DELETE /v1/users/:user_id/block' do
    it 'unblocks users' do
      User.first.block_friend User.second
      blocked_count = User.first.blocked_friends.count
      delete v1_user_block_path(User.second), headers: sign_in(User.first, 'ferrari458')
      expect(response).to have_http_status(204)
      expect(blocked_count).to eq(User.first.blocked_friends.count + 1)
      expect(!User.first.blocked_friends.include?(User.second))
    end
  end

end
