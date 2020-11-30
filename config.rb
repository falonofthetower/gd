# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/activerecord'
Dir[File.join(__dir__, 'models', '*.rb')].each { |file| require file }
require './requests'
require 'json'
