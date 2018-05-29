module Api
  module V1
    class UserProfileController < BaseController

      def show
        data = {
          user: d_current_user,
          user_profile: d_current_user.user_profile
        }
        success_json('User Profile Data',data)
      end

      def update
        up = User.find(d_current_user.id).user_profile

        if up.blank?
          up = User.find(d_current_user.id).build_user_profile
          up.save
        end
        if up.update_attributes(user_profile_params)
          success_json('User profile updated',up)
        else
          failed_json('User profile not updated',up.errors)
        end
        
      end

      private

      def user_profile_params
        params.permit(:name,:phone)
      end
      
    end
  end
end
