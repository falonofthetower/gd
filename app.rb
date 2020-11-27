# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/activerecord'
require './models'
require 'json'

class Library < Sinatra::Base
  get '/request' do
    content_type :json

    requests = Request.all.map(&:serialize)
    {
      requests: requests
    }.to_json
  end
end
