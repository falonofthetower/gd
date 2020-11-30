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
      let(:email) { "fake@example.com" }
      let!(:book) { Book.create(title: 'foobar') }

      it 'returns status 201' do
        post "/request", { :title => book.title, :email => email }.to_json

        expect(last_response.status).to eq 201
      end

      it 'creates an active request' do
        expect {
          post "/request", { :title => book.title, :email => email }.to_json
        }.to change(Request, :count).by(1)
      end

      it 'creates the request with expected data' do
        post "/request", { :title => book.title, :email => email }.to_json

        request = Request.last

        expect(request.book).to eq book
        expect(request.email).to eq request.email
      end

      it 'displays the request data with available' do
        post "/request", { :title => book.title, :email => email }.to_json

        request = Request.last

        expected_response = {
          'id' => request.id,
          'available' => true,
          'title' => request.book.title,
          'email' => request.email,
          'timestamp' => request.created_at.to_time.iso8601
        }

        expect(JSON.parse(last_response.body)).to eq(expected_response)
      end
    end

    context 'when the title is not available' do
      let(:email) { "fake@example.com" }
      let!(:book) { Book.create(title: 'foobar') }

      it 'displays the request data with not available' do
        post "/request", { :title => book.title, :email => "old@example.com" }.to_json
        post "/request", { :title => book.title, :email => email }.to_json


        request = Request.last

        expected_response = {
          'id' => request.id,
          'available' => false,
          'title' => request.book.title,
          'email' => request.email,
          'timestamp' => request.created_at.to_time.iso8601
        }

        expect(JSON.parse(last_response.body)).to eq(expected_response)
      end
    end

    context 'when the title does not exist' do
      let(:email) { "fake@example.com" }

      it 'displays the request data with not available' do
        post "/request", { :title => "unreal title", :email => email }.to_json

        expect(last_response.status).to eq 404
        expect(JSON.parse(last_response.body)).to eq({})
      end
    end
  end

  context 'DELETE /request/:id' do
    context 'with a matching request' do
      let(:book) { Book.create(title: "My Title") }
      let!(:request) { Request.create(book: book, email: "email@example.com") }

      it 'returns status 204' do
        delete "/request/#{request.id}"

        expect(last_response.status).to eq 202
      end

      it 'returns an empty response' do
        delete "/request/#{request.id}"

        expect(JSON.parse(last_response.body)).to eq({})
      end

      it 'deletes the request' do
        delete "/request/#{request.id}"

        expect(Request.find_by(id: request.id)).to be_nil
      end
    end

    context 'without a matching request' do
      it 'returns status 404' do
        delete "/request/0"

        expect(last_response.status).to eq 404
      end

      it 'returns an empty response' do
        delete "/request/0"

        expect(JSON.parse(last_response.body)).to eq({})
      end
    end
  end
end
