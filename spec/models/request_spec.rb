# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Request do
  let(:book) { Book.create(title: 'foobar') }
  let(:request) { Request.create(email: 'foo@example.com', book: book) }

  it 'belongs_to a book' do
    expect(request.book).to eq book
  end

  it 'validates against invalid emails' do
    expect(Request.new(book: book, email: 'xx%foo.com').valid?).to be_falsey
  end
end
