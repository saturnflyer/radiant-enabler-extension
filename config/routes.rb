ActionController::Routing::Routes.draw do |map|  
  map.namespace :admin do |admin|
    admin.enable_application 'enable/:api_key', :controller => 'enabler', :action => 'enable'
    admin.disable_application 'disable/:api_key', :controller => 'enabler', :action => 'disable'
  end
end