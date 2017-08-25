class RegistrationsController < Devise::RegistrationsController
  #overload the update resource update resource
  protected

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

end
