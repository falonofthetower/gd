# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Book do
  describe '#available?' do
    let(:book) { Book.create(title: 'foobar') }

    context 'with no open requests' do
      it 'returns truthy' do
        expect(book.available?).to be_truthy
      end
    end

    context 'with an open request' do
      let!(:request) { Request.create(email: 'foo@example.com', book: book) }

      it 'returns falsey' do
        expect(book.available?).to be_falsey
      end

      it 'returns the request from .request' do
        expect(book.requests).to include(request)
      end

      it 'deletes the request if deleted' do
        book.destroy

        expect(Request.find_by(id: request.id)).to be_nil
      end
    end
  end
end
