require 'rails_helper'

describe V1::EventsController do
  before :all do
    3.times do
      create :event
      create :user
    end
  end

  context "GET /v1/events" do

    it "requires lat lng" do
      get v1_events_path, headers: sign_in(User.first, "ferrari458")
      expect(response).to have_http_status(400)
    end

    it "accepts lat, lng, rad" do
      get v1_events_path(lat: 1, lng: 1, rad: 1), headers: sign_in(User.first, "ferrari458")
      expect(response).to have_http_status(200)
    end

  end

  context "POST /v1/events" do
    it "creates a new event" do
      data = {
        event: {
          name: "Fox Rok Ball",
          description: "Ball so damn hard",
          address: "Fox Chase Recreational Center",
        }
      }
      count = Event.count
      post v1_events_path, params: data, headers: sign_in(User.first, "ferrari458")
      expect(response).to have_http_status(200)
      expect(Event.count).to eq(count + 1)
      created_event = JSON.parse(response.body)
      expect(Event.find(created_event["id"])).not_to be_nil
    end

    it "fails with bad params" do
      data = {
        event: {
          name: "Fox Rok Ball",
          address: "Fox Chase Recreational Center",
          admin: true
        }
      }
      count = Event.count
      post v1_events_path, params: data, headers: sign_in(User.first, "ferrari458")
      expect(response).to have_http_status(400)
      expect(Event.count).to eq(count)
    end

    it "fails with invalid params" do
      data = {
        event: {
          name: "Fox Rok Ball",
          description: "Hey now",
          address: nil
        }
      }
      count = Event.count
      post v1_events_path, params: data, headers: sign_in(User.first, "ferrari458")
      expect(response).to have_http_status(422)
      expect(Event.count).to eq(count)
    end
  end

  context "PATCH /v1/events/:id" do
    it "updates models" do
      random = SecureRandom.base64
      data = {
        event: {
          description: random
        }
      }

      event = Event.first
      patch v1_event_path(event), params: data, headers: sign_in(event.owner, "ferrari458")
      expect(response).to have_http_status(200)
      get v1_event_path(event), headers: sign_in(User.first, "ferrari458")
      result = JSON.parse(response.body)
      expect(result["description"]).to eq(random)
    end

    it "fails with bad_params params" do
      data = {
        event: {
          bad_param: "evil_param"
        }
      }

      event = Event.first
      patch v1_event_path(event), params: data, headers: sign_in(event.owner, "ferrari458")
      expect(response).to have_http_status(400)
    end

    it "fails with invalid params" do
      data = {
        event: {
          address: ""
        }
      }

      event = Event.first
      patch v1_event_path(event), params: data, headers: sign_in(event.owner, "ferrari458")
      expect(response).to have_http_status(422)
    end
  end

  context "DELETE /v1/events/:id" do
    it "works" do
      event = Event.first
      count = Event.count
      delete v1_event_path(event), headers: sign_in(event.owner, "ferrari458")
      expect(response).to have_http_status(200)
      expect(Event.count).to eq(count - 1)
    end

    it "fails when not present" do
      event = Event.first
      event.destroy
      count = Event.count
      delete v1_event_path(event), headers: sign_in(event.owner, "ferrari458")
      expect(response).to have_http_status(404)
      expect(count).to eq(Event.count)
    end

  end

  context "POST /v1/events/:id/sign_up" do
    it "signs you up" do
      event = Event.first
      user = User.first
      sign_up_count = user.attending.count
      post v1_event_sign_up_path(event), headers: sign_in(user, 'ferrari458')
      expect(response).to have_http_status(204)
      expect event.attending.include?(user)
      expect user.attending.include?(event)
      expect(sign_up_count + 1).to eq(user.attending.count)
    end

    it "unsigns you up" do
      event = Event.first
      event_count = Event.count
      user = User.first
      user_count = User.count
      user.attending << event
      sign_up_count = user.attending.count
      post v1_event_unsign_up_path(event), headers: sign_in(user, 'ferrari458')
      expect(response).to have_http_status(204)
      expect !event.attending.include?(user)
      expect !user.attending.include?(event)
      expect(sign_up_count - 1).to eq(user.attending.count)
      expect(event_count).to eq(Event.count)
      expect(user_count).to eq(User.count)
    end
  end

end
