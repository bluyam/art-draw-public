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
    
    def weibo
      omniauth_process
    end
    
    protected
    def omniauth_process
      omniauth = request.env['omniauth.auth']
      authentication = Authentication.where(provider: omniauth.provider, uid: omniauth.uid.to_s).first
  
      if authentication
        set_flash_message(:notice, :signed_in)
        sign_in(:user, authentication.user)
        redirect_to root_path
      elsif current_user
        authentication = Authentication.create_from_hash(current_user.id, omniauth)
        set_flash_message(:notice, :add_provider_success)
        redirect_to authentications_path
      else
        session[:omniauth] = omniauth.except("extra")
        set_flash_message(:notice, :fill_your_email)
        redirect_to new_user_registration_url
      end
    end
  
    def after_omniauth_failure_path_for(scope)
      new_user_registration_path
    end

    # def failure
    #   redirect_to root_path
    # end
end