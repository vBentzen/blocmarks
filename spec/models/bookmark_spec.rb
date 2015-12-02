require 'rails_helper'
include RandomData

RSpec.describe Bookmark, type: :model do
  let(:topic) { create(:topic) }
  let(:bookmark) { create(:bookmark) }

  it { should belong_to(:topic) }

  describe "attributes" do
    it "should respond to url" do
      expect(bookmark).to respond_to(:url)
    end
  end
end