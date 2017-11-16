class SensorsController < ApplicationController
  skip_before_action :authenticate_request
  
  @@SensorStorage = SensorStorage.new

  def get_sensors_values
    render json: {temperature: @@SensorStorage.temperature, volume: @@SensorStorage.volume,
    machine_status: @@SensorStorage.machine_status}, status: :ok
  end
  
  def set_sensors_values
    @@SensorStorage.temperature = params[:temperature]
    @@SensorStorage.volume = params[:volume]
    @@SensorStorage.machine_status = params[:machine_status]
  end
end



