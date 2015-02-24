class CreatePermittedAppService
  def call
    permitted_app = PermittedApp.find_or_create_by!(authentication_token: Rails.application.secrets.api_master_key) do |app|
    end
  end
end
