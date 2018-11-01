require 'rails_helper'

describe V1::ThreadsController do

  before :each do
    3.times do
      create :event
      create :user
    end

    thread_gen Event.first.thread
  end

  context 'GET /v1/threads/:id' do
    it 'gets an array of comments' do
      get v1_thread_path(Event.first.thread), headers: sign_in(User.first, "ferrari458")
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).class).to eq(Array)
    end

    it 'returns in posting order' do
      get v1_thread_path(Event.first.thread), headers: sign_in(User.first, "ferrari458")
      expect(response).to have_http_status(200)
      comments = JSON.parse(response.body)
      (0..(comments.count - 2)).each do |i|
        comments[i]['created_at'].to_time > comments[i + 1]['created_at'].to_time
      end

    end
  end

end
