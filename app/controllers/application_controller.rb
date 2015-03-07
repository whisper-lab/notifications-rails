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
    root_path
  end

  def after_sign_out_path_for(resource_or_scope)
    request.referrer
  end
end
