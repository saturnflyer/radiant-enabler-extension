require File.dirname(__FILE__) + '/../spec_helper'

describe SiteController do  
  context "when the site is disabled" do
    it "should return text with the disabled message" do
      Radiant::Config['application.enabled?'] = false
      Radiant::Config['application.disabled_message'] = 'Site is down.'
      get :show_page, :url => '/any'
      response.body.should match('Site is down')
    end
  end
end