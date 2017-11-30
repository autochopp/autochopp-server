require 'rails_helper'

RSpec.describe ChoppsController, type: :controller do
  
  describe "GET #validate_qrcode" do
    it "returns http status ok when qrcode is valid" do
      user = User.create(email: "teste2@gmail.com", password: "123456")    
      order = Order.create(user: user)      
      chopp = Chopp.create(qrcode: "teste", qrcode_validate: true, size: 250,
      chopp_type: "tradicional", collar: 1, order: order)
      
      get :validate_qrcode, params: {qrcode: chopp.qrcode}
      expect(response).to have_http_status(:ok)      
    end

    it "returns http status ok when qrcode is invalid" do
      get :validate_qrcode, params: {qrcode: 'invalid'}
      expect(response).to have_http_status(:bad_request)      
    end      
  end
  
end
