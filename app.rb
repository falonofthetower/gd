# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/activerecord'
require './models'
require 'json'

class Library < Sinatra::Base
  get '/request' do
    content_type :json

    requests = Request.all.map { |r| r.serialize(:id, :email, :title, :timestamp) }
    {
      requests: requests
    }.to_json
  end

  get '/request/:id' do |id|
    content_type :json

    request = Request.find_by(id: id)

    if request
      request.serialize(:id, :available, :email, :title, :timestamp).to_json
    else
      status 404
      {}.to_json
    end
  end
end
