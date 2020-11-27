require "spec_helper"

RSpec.describe Library do
  let(:library) { Library.new }

  context "GET to /request" do
    it "returns status 200" do
    end

    it "returns all the requests in the system" do
    end
  end

  context "GET to /request/:id" do
    context "when request exists" do
      it "returns status 200" do
      end

      it "returns data on the specified request" do
      end
    end

    context "when request does not exists" do
      it "returns status 404" do
      end

      it "returns an empty response" do
      end
    end
  end

  context "POST to /request" do
    context "when the title is available" do
      it "returns status 201" do
      end

      it "displays the request data with available" do
      end

      it "creates an active request" do
      end
    end

    context "when the title is not available" do
      it "displays the request data with not available" do
      end
    end
  end

  context "DELETE /request/:id" do
    context "with a matching request" do
      it "returns status 204" do
      end

      it "returns an empty response" do
      end
    end

    context "without a matching request" do
      it "returns status 404" do
      end

      it "returns an empty response" do
      end
    end
  end
end
