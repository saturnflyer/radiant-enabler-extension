# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application_controller'

class EnablerExtension < Radiant::Extension
  version "#{File.read(File.expand_path(File.dirname(__FILE__)) + '/VERSION')}"
  description "Keeps your site going"
  url "http://www.saturnflyer.com"
  
  def activate
    Radiant::Config['application.enabled?'] = true if Radiant::Config['application.enabled?'].nil?
    if Radiant::Config['application.disabled_message'].nil?
      Radiant::Config['application.disabled_message'] = "Sorry, but this site has been disabled."
    end
    SiteController.class_eval {
      before_filter :filter_by_application_status
      
      def filter_by_application_status
        unless Radiant::Config['application.enabled?']
          expires_in 24.hours, :public => true, :private => false
          headers['ETag'] = ''
          render :text => Radiant::Config['application.disabled_message'] and return
        end
      end
    }
  end
end
