# frozen_string_literal: true

class Book < ActiveRecord::Base
  has_many :requests

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
