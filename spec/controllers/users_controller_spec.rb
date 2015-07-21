require "rails_helper"

RSpec.describe UsersController, type: :controller do
  describe "GET #index" do
    let(:attr1) do
      { name: "Example user 1", email: "user1@example.com", password: "123456", 
      password_confirmation: "123456" }
    end
    
    let(:attr2) do
      { name: "Example user 2", email: "user2@example.com", password: "123456", 
      password_confirmation: "123456" }
    end
  
    it "responds successfully with an HTTP 200 status code" do
      get :index
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end
    
    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
    
    it "loads all of the users into @users" do
      user1, user2 = User.create!(attr1), User.create!(attr2)
      get :index
      expect(assigns(:users)).to match_array([user1, user2])
    end
  end
end