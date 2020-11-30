# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/activerecord'
require './models'
require './requests'
require 'json'

class Library < Sinatra::Base
  get '/request' do
    content_type :json
    requests = Requests.all_active.map do |request|
      request.serialize(:id, :email, :title, :timestamp)
    end

    { requests: requests }.to_json
  end

  get '/request/:id' do |id|
    content_type :json

    request = Requests.find(id)

    if request
      request.serialize(:id, :email, :title, :timestamp).to_json
    else
      status 404
      {}.to_json
    end
  end

  post '/request' do
    content_type :json

    email = params["email"]
    title = params["title"]

    request, available = Requests.reserve_book(title, email)

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
    content_type :json

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
