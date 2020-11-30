# frozen_string_literal: true

require './config'

class Library < Sinatra::Base
  before do
    content_type :json
    request.body.rewind
    string_json = request.body.read
    @json = (string_json == "") ? {} : JSON.parse(string_json)
  end

  get '/request' do
    requests = Requests.all_active.map do |request|
      request.serialize(:id, :email, :title, :timestamp)
    end

    { requests: requests }.to_json
  end

  get '/request/:id' do |id|
    request = Requests.find(id)

    if request
      request.serialize(:id, :email, :title, :timestamp).to_json
    else
      status 404
      {}.to_json
    end
  end

  post '/request' do
    request, available = Requests.reserve_book(
      @json["title"], @json["email"]
    )

    if request
      status 201
      request.serialize(
        :id, :email, :title, :timestamp
      ).merge(available: available).to_json
    else
      status 404
      {}.to_json
    end
  end

  delete '/request/:id' do |id|
    destruction = Requests.destroy_request(id)
    if destruction
      status 202
      {}.to_json
    else
      status 404
      {}.to_json
    end
  end
end
