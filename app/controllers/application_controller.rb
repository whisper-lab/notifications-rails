class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  protect_from_forgery with: :null_session, :if => Proc.new { |c| c.request.format == 'application/json' }

  rescue_from StandardError do |exception|
    # Add your own call to your exception notification system here.
    if request.format.json?

      message = "\n#{exception.class} (#{exception.message}):\n"
      message << exception.annoted_source_code.to_s if exception.respond_to?(:annoted_source_code)
      message << "  " << ActionDispatch::ExceptionWrapper.new(env, exception).application_trace.join("\n  ")
      logger.error("#{message}\n\n")

      render json: { message: 'Internal server error' }, status: :internal_server_error
    else
      raise(exception)
    end
  end

  def after_sign_in_path_for(resource)
    path = stored_location_for :user
    path ? path : channels_path
    # root_path
  end

  def after_sign_out_path_for(resource_or_scope)
    request.referrer
  end

  protected

    def authenticate_app_from_token!
      authenticate_or_request_with_http_token do |token, options|
        @permitted_app = PermittedApp.where(authentication_token: token).first
      end
    end

    def authenticate
      authenticate_or_request_with_http_token do |token, options|
        email, api_key = token.split(':', 2)
        @current_user = User.where(email:email, api_key: api_key).first
      end
    end

    # NOTE: For ref
    # Manual way of authenticate request
    def authenticate_manual
      api_key = request.headers['X-Api-Key']
      @user = User.where(api_key: api_key).first if api_key

      unless @user
        head status: :unauthorized
        return false
      end
    end

    # Check request per min
    # You can add field to user table request per min or define constant.
    # Here I am just passsing some random value
    def validate_rpm
      if ApiRpmStore.threshold?(@user.id, @user.api_rpm) # 10 request per min
        render json: { help: 'http://mysite.com/plans' }, status: :too_many_requests
        return false
      end
    end
end
