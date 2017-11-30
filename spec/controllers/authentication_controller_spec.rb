require 'rails_helper'

RSpec.describe AuthenticationController, type: :controller do

  describe "POST #authenticate" do
    it "returns http status ok when user is valid" do
      user = User.create(email: "teste@gmail.com", password: "123456")          
      post :authenticate, params: {email: user.email, password: user.password}
      expect(response).to have_http_status(:ok)      
    end
  end

  describe "POST #authenticate" do
    it "returns http status unauthorized when user is invalid" do
      user = User.create(email: "teste@gmail.com", password: "123456")          
      post :authenticate, params: {email: user.email, password: "654321"}
      expect(response).to have_http_status(:unauthorized)      
    end
  end

end
