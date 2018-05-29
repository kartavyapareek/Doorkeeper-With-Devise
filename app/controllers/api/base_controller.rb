module Api
  class BaseController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :d_current_user
    before_action :doorkeeper_authorize!
    

    def success_json(message, data)
      render  json: { 
                      status: 'SUCCESS', 
                      message: message, 
                      data: data
                    },
              status: :ok
    end

    def failed_json(message,data = nil)
      render  json: { 
                      status: 'ERROR', 
                      message: message, 
                      data: data
                    },
              status: :unprocessable_entity
    end

    private
      def d_current_user
        if doorkeeper_token.present?
          @d_current_user ||= User.find(doorkeeper_token[:resource_owner_id])
        end
      end

    def doorkeeper_unauthorized_render_options(error: nil)
      {
        json: { 
                status: 'ERROR', 
                messgae: 'Access token expired', 
                data: 'Not authorized ! '
              },
        status: :Not_authorized
      }
    end   
  end
end
