class AuthController < ApplicationController
  OAUTH_BASE_URL = 'https://oauth-latest.dev.lcip.org/v1'
  OAUTH_CLIENT_ID = '1f9bbddcb3e160ab'
  OAUTH_CLIENT_SECRET = '24bf8caeaa685e2e42d9a75b48511f83adffaf6fcdd174ce8749358a376be911'

  PROFILE_BASE_URL = 'https://latest.dev.lcip.org/profile/v1'

  def sign_in
    # Create a nonce that we can verify upon completion
    state = session[:oauth_state] = SecureRandom.hex(8)
    action = params[:action] == 'signup' ? 'signup' : 'signin'

    redirect_to "#{OAUTH_BASE_URL}/authorization?client_id=#{OAUTH_CLIENT_ID}&state=#{state}&action=#{action}&scope=profile"
  end

  def complete
    # Verify oauth state value
    if session[:oauth_state] == params[:state]
      # Remove oauth state so it can't be used again
      session.delete(:oauth_state)

      # Fetch token from the oauth server
      token = fetch_token(params[:code])

      oauth_token = token['access_token']
      oauth_token_type = token['token_type']

      # Fetch profile from the profile server
      profile = fetch_profile(oauth_token, oauth_token_type)

      # Lookup the user by uid
      user = User.where(fxa_id: profile['uid']).first_or_initialize

      user.email = profile['email']
      user.oauth_token = oauth_token
      user.oauth_token_type = oauth_token_type

      user.save!

      self.current_user = user
    end

    redirect_to '/'
  end

  def sign_out
    session.delete(:user_id)

    redirect_to '/'
  end

  private

    def fetch_token(code)
      response = RestClient.post("#{OAUTH_BASE_URL}/token", { client_id: OAUTH_CLIENT_ID, client_secret: OAUTH_CLIENT_SECRET, code: code }.to_json, content_type: :json)

      JSON.parse(response)
    end

    def fetch_profile(oauth_token, oauth_token_type)
      response = RestClient.get("#{PROFILE_BASE_URL}/profile", authorization: "#{oauth_token_type.capitalize} #{oauth_token}")

      JSON.parse(response)
    end
end
