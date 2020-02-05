module DeviseTokenAuth
    class Auth::ConfirmationsController < DeviseTokenAuth::ConfirmationsController
        def show
            @resources = resource_class.confirm_by_token(params[:confirmation_token])
            if @resources.errors.empty?
                redirect_to(ENV['CONFIRM_URL'] + "?confirmedEmail=#{@resources.email}")
            else
                redirect_to(ENV['CONFIRM_URL'] + "?error=500")
            end
        end
    end
end
