require 'rails_helper'

RSpec.describe SensorsController, type: :controller do

  describe "GET #getsensors" do
    it "returns http status ok" do
      get :get_sensors_values
      expect(response).to have_http_status(:ok)      
    end
  end

  describe "POST #setsensors" do
    it "returns http status no_content" do
      post :set_sensors_values, params: {temperature: "5", volume: "25000", machine_status: "true"}
      expect(response).to have_http_status(:no_content)      
    end
  end

end
