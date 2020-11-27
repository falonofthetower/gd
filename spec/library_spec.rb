# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Library do
  let(:app) { Library.new }

  context 'GET to /request' do
    context 'with no requests in system' do
      it 'returns status 200' do
        get '/request'

        expect(last_response.status).to eq 200
      end

      it 'returns empty response' do
        get '/request' do
          expect(JSON.parse(last_response.body)).to eq(
            {
              'requests' => []
            }
          )
        end
      end
    end

    context 'with requests in system' do
      let!(:book1) { Book.create(title: 'Title One') }
      let!(:book2) { Book.create(title: 'Title Two') }
      let!(:email1) { 'fake1@example.com' }
      let!(:email2) { 'fake2@example.com' }
      let!(:request1) { Request.create(book: book1, email: email1) }
      let!(:request2) { Request.create(book: book2, email: email2) }

      it 'returns status 200' do
        get '/request'

        expect(last_response.status).to eq 200
      end

      it 'returns all the requests in the system' do
        get '/request'

        expected_response = {
          'requests' => [
            {
              'id' => request1.id,
              'title' => request1.book.title,
              'email' => request1.email,
              'timestamp' => request1.created_at.to_time.iso8601
            },
            {
              'id' => request2.id,
              'title' => request2.book.title,
              'email' => request2.email,
              'timestamp' => request2.created_at.to_time.iso8601
            }
          ]
        }

        expect(JSON.parse(last_response.body)).to eq(expected_response)
      end
    end
  end

  context 'GET to /request/:id' do
    context 'when request exists' do
      let!(:book1) { Book.create(title: 'Title One') }
      let(:request) { Request.create(email: 'fake@example.com', book: book1) }

      it 'returns status 200' do
        get "/request/#{request.id}"

        expect(last_response.status).to eq 200
      end

      it 'returns data on the specified request' do
        get "/request/#{request.id}"

        expected_response = {
          'id' => request.id,
          'available' => request.book.available?,
          'title' => request.book.title,
          'email' => request.email,
          'timestamp' => request.created_at.to_time.iso8601
        }

        expect(JSON.parse(last_response.body)).to eq(expected_response)
      end
    end

    context 'when request does not exists' do
      it 'returns status 404' do
        get '/request/0'

        expect(last_response.status).to eq 404
      end

      it 'returns an empty response' do
        get '/request/0'

        expect(JSON.parse(last_response.body)).to eq({})
      end
    end
  end

  context 'POST to /request' do
    context 'when the title is available' do
      it 'returns status 201' do
      end

      it 'displays the request data with available' do
      end

      it 'creates an active request' do
      end
    end

    context 'when the title is not available' do
      it 'displays the request data with not available' do
      end
    end
  end

  context 'DELETE /request/:id' do
    context 'with a matching request' do
      it 'returns status 204' do
      end

      it 'returns an empty response' do
      end
    end

    context 'without a matching request' do
      it 'returns status 404' do
      end

      it 'returns an empty response' do
      end
    end
  end
end
