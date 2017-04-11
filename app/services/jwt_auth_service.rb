class JWTAuthService
  attr_reader :uid

  def initialize(authorization_header)
    @authorization_header = authorization_header
  end

  def authenticate
    jwt_token = read_token
    raise 'Token not provided' if jwt_token.strip.empty?

    decoded_token = decode_token(jwt_token)
    @uid = decoded_token.first['sub']
  end

  def authenticated?
    @uid != nil
  end

  private
    def firebase_public_key
      # TODO: Implement cache control based on value of max-age
      uri = URI('https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com')
      public_keys = JSON.parse(Net::HTTP.get(uri))
      public_keys.first[1]
    end

    def read_token
      @authorization_header.scan(/Bearer(.*)$/).flatten.last
    end

    def decode_token(jwt_token)
      x509 = OpenSSL::X509::Certificate.new firebase_public_key

      # TODO: Implement verification for aud, iss
      JWT.decode(jwt_token.strip, x509.public_key, true, { algorithm: "RS256", verify_iat: true })
    end
end
