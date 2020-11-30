# frozen_string_literal: true

class Book < ActiveRecord::Base
  has_many :requests, dependent: :destroy
  validates_uniqueness_of :title

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
