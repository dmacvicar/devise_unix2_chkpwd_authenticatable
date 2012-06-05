require 'devise_unix2_chkpwd_authenticatable/strategy'
require 'open3'

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
        Rails.logger.info "*** UNIX2_CHKPWD: checking password for user #{login.inspect}"

        success = nil

        # check Ruby version
        if RUBY_VERSION.match /^1.8/
          # open3 does not return the exit status correctly
          # use echo to print it to stdout
          Open3.popen3("/sbin/unix2_chkpwd passwd '#{escape_quotes login}'; echo $?") do |stdin, stdout, stderr|
            stdin.write passwd
            stdin.close
            error = stderr.read
            Rails.logger.error "*** UNIX2_CHKPWD: Password check failed: #{error}" if error
            success = stdout.read == "0\n"
         end
        else
          # Ruby 1.9 (or higher)
          Open3.popen3("/sbin/unix2_chkpwd", "passwd", login) do |stdin, stdout, stderr, wait_thr|
            stdin.write passwd
            stdin.close
            error = stderr.read
            Rails.logger.error "*** UNIX2_CHKPWD: Password check failed: #{error}" if error
            success = wait_thr.value.exitstatus == 0
          end
        end

        return success
      end

      private

      def escape_quotes(cmd)
        cmd.gsub /'/,"'\\\\''"
      end

      public

      module ClassMethods
    
        def authenticate_with_unix2_chkpwd(attributes={})
         Rails.logger.debug "*** Authenticate with UNIX2_CHKPWD, username: #{attributes[:username].inspect}"
         return nil unless attributes[:username].present?

         resource = scoped.where(:username => attributes[:username]).first

         if resource.blank?
           resource = new
           resource[:username] = attributes[:username]
           resource[:password] = attributes[:password]
         end

         if resource.try(:unix2_chkpwd, attributes[:username], attributes[:password])
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

