class ApplicationController < ActionController::Base
  include ControllerAuthentication
  include ActionView::Helpers::RawOutputHelper

  protect_from_forgery

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

end
