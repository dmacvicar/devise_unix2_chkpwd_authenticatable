# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = 'devise_unix2_chkpwd_authenticatable'
  s.version = "0.1"
  s.authors = ['Vladislav Lewin']
  s.date = '2011-01-13'
  s.description = 'For authenticating against PAM (Pluggable Authentication Modules)'
  s.email = 'vlewin@suse.de'
  s.extra_rdoc_files = [
    'README.rdoc'
  ]
  s.files = [
    #"MIT-LICENSE",
    'README.rdoc',
    #'Rakefile',
    #'VERSION',
    'devise_pam_authenticatable.gemspec',
    'lib/devise_pam_authenticatable.rb',
    'lib/devise_pam_authenticatable/model.rb',
    #'lib/devise_pam_authenticatable/pam_adapter.rb',
    'lib/devise_pam_authenticatable/routes.rb',
    'lib/devise_pam_authenticatable/strategy.rb',
    'rails/init.rb'
  ]
  s.homepage = 'http://github.com/dmacvicar/devise_unix2_chkpwd_authenticatable'
  s.require_paths = ['lib']
  s.rubygems_version = '1.4.2'
  s.summary = 'Devise PAM authentication module using unix2_chkpwd'

  s.add_runtime_dependency('devise', ["> 1.1.0"])

end

