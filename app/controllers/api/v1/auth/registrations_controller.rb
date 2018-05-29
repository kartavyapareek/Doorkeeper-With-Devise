module Api
  module V1
    module Auth
      class RegistrationsController < Devise::RegistrationsController
        prepend_before_action :require_no_authentication, :only => [:create]
        skip_before_action :verify_authenticity_token, :only => [:create]

        before_action :ensure_params_exist
        respond_to :json

        def create
          build_resource(sign_up_params)
          resource.save
          yield resource if block_given?
          if resource.persisted?
            if resource.active_for_authentication?
              sign_up(resource_name, resource)
              success_json('sign up successfully', current_user)
            else
              failed_json('Sign up not successfully')
            end
          else
            failed_json('Sign up not successfully',resource.errors)
          end
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
