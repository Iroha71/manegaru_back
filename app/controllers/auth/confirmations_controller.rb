module DeviseTokenAuth
    class Auth::ConfirmationsController < DeviseTokenAuth::ConfirmationsController
        def show
            @resources = resource_class.confirm_by_token(params[:confirmation_token])
            if @resources.errors.empty?
                redirect_to(ENV['CONFIRM_URL'])
            else
                railse ActionController::RoutingError, 'Not Found'
            end
        end
    end
end
