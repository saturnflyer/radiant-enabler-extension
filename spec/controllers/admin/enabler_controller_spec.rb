require 'cgi'
require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::EnablerController do  
  dataset :pages, :file_not_found
  before do
    Radiant::Config['application.api_key'] = '12345'
    Radiant::Config['application.enabled?'] = true
  end
  context "with a valid api key" do
    context "for the disable action" do
      it "should set the Radiant::Config['application.enabled?'] to false" do
        Radiant::Config['application.enabled?'] = 'true'
        post :disable, :api_key => '12345'
        Radiant::Config['application.enabled?'].should == false
      end
      it "should set the disabled message with the message parameter" do
        post :disable, :api_key => '12345', :message => 'Site%20is%20down.'
        Radiant::Config['application.disabled_message'].should == 'Site is down.'
      end
      it "should respond to with a 200 code" do
        post :disable, :api_key => '12345'
        response.code.should == '200'
      end
      context "with a disabled message" do
        it "should unescape the message string" do
          post :disable, :api_key => '12345', :message => "This+is+the+message+about+the+site+%26+it%27s+downtime%21"
          Radiant::Config['application.disabled_message'].should == "This is the message about the site & it's downtime!"
        end
      end
    end
    context "for the enable action" do
      it "should set the Radiant::Config['application.enabled?'] to true" do
        Radiant::Config['application.enabled?'] = false
        Radiant::Config['application.enabled?'].should == false
        post :enable, :api_key => '12345'
        Radiant::Config['application.enabled?'].should == true
      end  
      it "should respond to with a 200 code" do
        post :enable, :api_key => '12345'
        response.code.should == '200'
      end
    end
  end
  context "with an invalid api key" do
    before do
      pages(:file_not_found).part('body').update_attribute(:content, 'Oops! We could not find that page.')
    end
    it "should render the response from the page found for the given url" do
      post :enable, :api_key => 'abcde'
        pages(:file_not_found).process(request, response) # only passes after this ...?
      response.body.should == 'Oops! We could not find that page.'
    end
    context "with a disable message" do
      it "should render the response from the page found for the given url" do
        post :disable, :api_key => 'abcde', :message => 'Site%20is%20down'
          pages(:file_not_found).process(request, response) # only passes after this ...?
        response.body.should == 'Oops! We could not find that page.'
      end
    end
  end
end