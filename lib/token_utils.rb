class TokenUtils
  JWT_SECRET = ENV["JWT_SECRET"]  
  class << self
    
    def encode(payload, exp = 24.hours.from_now)
      payload[:exp] = exp.to_i
      JWT.encode(payload, JWT_SECRET)
    end

    def decode(token)
      JWT.decode(token, JWT_SECRET)
    end

  end
end