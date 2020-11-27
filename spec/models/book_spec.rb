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
      it 'returns falsey' do
        Request.create(email: 'foo@example.com', book: book)

        expect(book.available?).to be_falsey
      end
    end
  end
end
