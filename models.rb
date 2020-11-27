# frozen_string_literal: true

class Book < ActiveRecord::Base
  has_many :requests

  def serialize
    {
      id: id,
      title: title
    }
  end
end

class Request < ActiveRecord::Base
  belongs_to :book

  def serialize
    {
      id: id,
      title: book.title,
      email: email,
      timestamp: created_at.to_time.iso8601
    }
  end
end
