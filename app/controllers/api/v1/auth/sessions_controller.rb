module Api
  module V1
    module Auth
      class SessionsController < Devise::SessionsController
        prepend_before_action :require_no_authentication, :only => [:create ]
        skip_before_action :verify_authenticity_token, :only => [:create ,:failure,:destroy]

        before_action :ensure_params_exist
        respond_to :json

        def create
          res = User.find_by(email: params[:user][:email])
          if res.nil?
            failed_json('Invalid Email address')     
          else
            warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
            success_json('Login successfully',current_user)
          end
        end

        def destroy
          signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
          if signed_out
            success_json('Log out successfully','User Sign Out')
          else
            failed_json('Log out failed')
          end
        end

        def failure
          failed_json('error with email and password')
        end

        protected

        def ensure_params_exist
          return unless params[:user].blank?
          failed_json('Sign up not successfully','Missing user signup parameter')
        end

        def success_json(message, data)
          render  json: { 
                          status: 'SUCCESS', 
                          message: message, 
                          data: data
                        },
                  status: :ok
        end

        def failed_json(message, data = nil)
          render  json: { 
                          status: 'ERROR', 
                          message: message, 
                          data: data
                        },
                  status: :unprocessable_entity
        end
      end
    end
  end
end
