class Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController
    def sign_up_params
        params.require(:registration).permit(:name, :nickname, :image, :email, :password, :personal_pronoun, :girl_id)
    end

    def account_update_params
        params.require(:registration).permit(:name, :nickname, :image, :email, :personal_pronoun, :girl_id, :notify_method)
    end
end