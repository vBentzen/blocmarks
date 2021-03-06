require 'rails_helper'
include RandomData

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  it { should have_many(:likes) }
  # Shoulda tests for login
  # it { should validate_presence_of(:login) }
  # Shoulda tests for email
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should allow_value("user@bloccit.com").for(:email) }
  it { should_not allow_value("userbloccit.com").for(:email) }
  # Shoulda tests for password
  it { should validate_presence_of(:password) }
  it { should validate_length_of(:password).is_at_least(8) }

  describe "attributes" do
    it "should respond to email" do
      expect(user).to respond_to(:email)
    end
    it "should respond to admin?" do
      expect(user).to respond_to(:admin?)
    end
  end

  describe "invalid user" do
    let(:user_with_invalid_username) { User.new(username: "", email: "user@blocmarks.com") }
    let(:user_with_invalid_email) { User.new(username: "Blocmarks User", email: "") }
    let(:user_with_invalid_email_format) { User.new(username: "Blocmarks User", email: "invalid_format") }

    it "should be an invalid user due to blank username" do
      expect(user_with_invalid_username).to_not be_valid
    end
    it "should be an invalid user due to blank email" do
      expect(user_with_invalid_email).to_not be_valid
    end
    it "should be an invalid user due to incorrectly formatted email address" do
      expect(user_with_invalid_email_format).to_not be_valid
    end
  end

  describe "admin user" do
    before do
      user.update_attributes(admin: true)
    end

    it "should return true for #admin?" do
      expect(user.admin?).to be_truthy
    end
  end

  describe "reassign_topics_to_new_users" do
    it "should reassign a topic to other_user" do
      topic = create(:topic, user: user)
      topic_count = Topic.count
      other_user = User.create(email: "newuser@example.com", password: "helloworld", password_confirmation: "helloworld")
      other_user_bookmark = create(:bookmark, topic: topic, user: other_user)
      expect{user.destroy}.to_not change{Topic.count}
    end
    it "should delete a topic if there is no user to reassign it to" do
      topic = create(:topic, user: user)
      topic_count = Topic.count
      expect{user.destroy}.to change{Topic.count}.from(1).to(0)
      # user.destroy
      # expect(user.destroyed?).to eq true
      # expect(topic.destroyed?).to eq true
      # expect(Topic.count).to eq topic_count - 1
    end
  end

end
