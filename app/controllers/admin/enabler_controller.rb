require 'cgi'
class Admin::EnablerController < ApplicationController
  no_login_required
  skip_before_filter :validate_authenticity
  
  def enable
    if Radiant::Config['application.api_key'] == params[:api_key] && request.post?
      Radiant::Config['application.enabled?'] = true
      Radiant::Cache.clear
      respond_to do |format|
        format.any { head :ok }
      end
    else
      Page.find_by_url(request.request_uri).process(request, response)
    end
  end
  
  def disable
    if Radiant::Config['application.api_key'] == params[:api_key] && request.post?
      Radiant::Config['application.enabled?'] = false
      if params[:message]
        Radiant::Config['application.disabled_message'] = CGI.unescape(params[:message])
      end
      Radiant::Cache.clear
      respond_to do |format|
        format.any { head :ok }
      end
    else
      Page.find_by_url(request.request_uri).process(request, response)
    end
  end
end