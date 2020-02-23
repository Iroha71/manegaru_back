module DeviseTokenAuth
    class Auth::ConfirmationsController < DeviseTokenAuth::ConfirmationsController
        def show
            @resources = resource_class.confirm_by_token(params[:confirmation_token])
            is_created_project = Project.create_default_project(@resources.id).eql?('success') ? true : false
            if @resources.errors.empty?
                redirect_to(ENV['CLIENT_URL'] + 'user/confirmed' + "?confirmedEmail=#{@resources.email}" + "&existProject=#{is_created_project}")
            else
                redirect_to(ENV['CLIENT_URL'] + 'user/confirmed' + "?error=500")
            end
        end
    end
end
