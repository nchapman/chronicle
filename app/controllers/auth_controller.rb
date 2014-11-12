class AuthController < ApplicationController
  def sign_in
    # Create a nonce that we can verify upon completion
    state = session[:oauth_state] = SecureRandom.hex(8)
    action = params[:action] == 'signup' ? 'signup' : 'signin'

    redirect_to get_oauth_redirect_url(state, action)
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

      # Lookup the user by fxa uid
      user = User.where(fxa_uid: profile['uid']).first_or_initialize

      user.email = profile['email']
      user.oauth_token = oauth_token
      user.oauth_token_type = oauth_token_type

      user.save!

      # Sign in the user
      self.current_user = user
    end

    redirect_back_or_default
  end

  def sign_out
    forget_current_user

    redirect_to root_path
  end

  private

    def get_oauth_redirect_url(state, action)
      "#{AppConfig.oauth.base_url}/authorization?client_id=#{AppConfig.oauth.client.id}&state=#{state}&action=#{action}&scope=profile"
    end

    def fetch_token(code)
      response = RestClient.post("#{AppConfig.oauth.base_url}/token", { client_id: AppConfig.oauth.client.id, client_secret: AppConfig.oauth.client.secret, code: code }.to_json, content_type: :json)

      JSON.parse(response)
    end

    def fetch_profile(oauth_token, oauth_token_type)
      response = RestClient.get("#{AppConfig.oauth.profile.base_url}/profile", authorization: "#{oauth_token_type.capitalize} #{oauth_token}")

      JSON.parse(response)
    end
end
