require 'devise'

%w(model strategy routes).each do |mod|
  require File.expand_path "../devise_unix2_chkpwd_authenticatable/#{mod}",__FILE__
end

Devise.add_module(:unix2_chkpwd_authenticatable, :strategy => true, :model => "devise_unix2_chkpwd_authenticatable/model", :route => true)
