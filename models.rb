# frozen_string_literal: true
require 'email_validator'

class Book < ActiveRecord::Base
  has_many :requests, dependent: :destroy

  def available?
    requests.empty?
  end

  def serialize
    {
      id: id,
      title: title
    }.slice(slice)
  end
end

class Request < ActiveRecord::Base
  belongs_to :book
  validates :email, email: true

  def serialize(*slice)
    {
      id: id,
      available: book.available?,
      email: email,
      title: book.title,
      timestamp: created_at.to_time.iso8601
    }.slice(*slice)
  end
end
