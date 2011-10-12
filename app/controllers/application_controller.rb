class ApplicationController < ActionController::Base
  include ControllerAuthentication
  include ActionView::Helpers::RawOutputHelper

  protect_from_forgery

  before_filter :prepare_for_mobile

  def fading_flash_message(text, seconds=3)
    raw text +
      <<-EOJS
        <script type='text/javascript'>
          Event.observe(window, 'load',function() { 
            setTimeout(function() {
              message_id = $('notice') ? 'notice' : 'warning';
              new Effect.Fade(message_id);
            }, #{seconds*1000});
          }, false);
        </script>
      EOJS
  end

  private
    def mobile_device?
      return false
      if session[:mobile_param]
        session[:mobile_param] == "1"
      else
        request.user_agent =~ /Mobile|webOS/
      end
    end

    helper_method :mobile_device?

    def prepare_for_mobile
      session[:mobile_param] = params[:mobile] if params[:mobile]
      request.format = :mobile if mobile_device?
    end

end
