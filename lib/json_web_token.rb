class JsonWebToken
  class << self

    def encode(payload, exp = 24.hours.from_now)
      payload[:exp] = exp.to_i
      JWT.encode(payload, Rails.application.secrets.secret_key_base)
    end

    def decode(token)
      body = JWT.decode(token, Rails.application.secrets.secret_key_base, true, {:algorithm => 'HS256'})
      HashWithIndifferentAccess.new body[0]
    rescue StandardError => error
      puts "The follow error happens..."
      puts error
      nil
    end
  end
end
