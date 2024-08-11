class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  def error_notice(msg)
    render turbo_stream: send_notice(msg, 'danger')
  end

  def success_notice(msg)
    send_notice(msg, 'success')
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  private

  def send_notice(msg, key)
    turbo_stream.append(:notices, partial: 'shared/notice', locals: { notices: msg, key: key })
  end
end
