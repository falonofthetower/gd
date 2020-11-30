class Requests
  class <<self
    def reserve_book(title, email)
      book = Book.find_by_title(title)

      if book
        available = book.available?
        request = Request.new(email: email, book: book)
        request.save
      end
      return [request, available] if request
    end

    def destroy_request(id)
      request = Requests.find(id)
      request && request.destroy || false
    end

    def find(id)
      Request.find_by(id: id)
    end

    def all_active
      Request.all
    end
  end
end
