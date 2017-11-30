require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  
  describe "GET #index" do
    it "returns http status ok" do
      get :index
      expect(response).to have_http_status(:ok)      
    end
  end
  
  describe "GET #show" do
    it "returns http status ok" do
      user = User.create(email: "teste@gmail.com", password: "123456")    
      get :show, params: {id: user}
      expect(response).to have_http_status(:ok)      
    end
  end
  
  describe "POST #create" do
    it "returns http status created when user data is valid" do
      post :create, params: {user: {email: "carlaaguiar@gmail.com", password: "123456"}}
      expect(response).to have_http_status(:created)      
    end
    
    it "return http status bad_request when user email is invalid" do
      post :create, params: {user: {email: "carla@gmail.com", password: "123456"}}
      expect(response).to have_http_status(:bad_request)  
    end  

    it "return http status bad_request when user email is already exists" do
      user = User.create(email: "carlaaguiar@gmail.com", password: "123456")          
      post :create, params: {user: {email: "carlaaguiar@gmail.com", password: "123456"}}
      expect(response).to have_http_status(:bad_request)  
    end    
  end

  describe "PUT #update" do
    it "returns http status ok when user data is valid" do
      user = User.create(email: "carlaaguiar@gmail.com", password: "123456")                
      put :update, params: {id: user, user: user.attributes = {email: "carlaaguiar@gmail.com", password: "654321"}}
      expect(response).to have_http_status(:ok)      
    end
  end

  
end
