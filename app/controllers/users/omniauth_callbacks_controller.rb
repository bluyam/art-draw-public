class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def facebook
      # You need to implement the method below in your model (e.g. app/models/user.rb)
      @user = User.from_omniauth(request.env["omniauth.auth"])
      # render @user.to_json
      if @user.persisted?
      #this will throw if @user is not activated
        set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
        sign_in_and_redirect @user, :event => :authentication
      else
        session["devise.user_attribute"] = @user.attributes
        redirect_to new_user_registration_url
      end
    end

    # def failure
    #   redirect_to root_path
    # end
end