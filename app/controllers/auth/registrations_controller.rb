class Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController
    def sign_up_params
        params.permit(:name, :nickname, :image, :email, :password, :personal_pronoun, :personality, :girl_id)
    end

    def account_update_params
        params.permit(:name, :nickname, :image, :email, :personal_pronoun, :personality, :girl_id, :notify_method)
    end
end