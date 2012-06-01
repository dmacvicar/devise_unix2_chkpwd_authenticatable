require 'devise_unix2_chkpwd_authenticatable/strategy'
require 'session'

module Devise
  module Models
    module Unix2ChkpwdAuthenticatable

      def self.included(base)
        base.class_eval do
          extend ClassMethods
          attr_accessor :password
        end
      end

      # Set password to nil
      def clean_up_passwords
        self.password = nil
      end

      def unix2_chkpwd(login, passwd)
        Rails.logger.error "*** UNIX2_CHKPWD #{login.inspect}"
        return false if login.include? ?' #blacklist login with ' in name

        cmd = "/sbin/unix2_chkpwd passwd '#{login}'"
        session = Session.new
        result, err = session.execute cmd, :stdin => passwd
        ret = session.get_status.zero?
        session.close
        ret
      end


      module ClassMethods
    
        def authenticate_with_unix2_chkpwd(attributes={})
         Rails.logger.info "*** Authenticate with UNIX2_CHKPWD user #{attributes[:username].inspect}"
         return nil if attributes[:username].blank?

         resource = scoped.where(:username => attributes[:username]).first

         if resource.blank?
           resource = new
           resource[:username] = attributes[:username]
           resource[:password] = attributes[:password]
         end

         if resource.unix2_chkpwd attributes[:username], attributes[:password]
           resource.save if resource.new_record?
           return resource
         else
           return nil
         end
  
       end
  
     end
  
    end
  end
end