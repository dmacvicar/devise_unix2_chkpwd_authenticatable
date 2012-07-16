require 'devise/strategies/base'

module Devise
  module Strategies
    class Unix2ChkpwdAuthenticatable < Base

      def valid?
        valid = (valid_params? || valid_http_auth?) && mapping.to.respond_to?(:authenticate_with_unix2_chkpwd)
        Rails.logger.debug "valid?: #{valid}"
        valid
      end

      def authenticate!
        credentials = params[scope]

        # credentials are empty when using HTTP auth
        if credentials.nil?
          # only HTTP Basic authentication is supported
          request.authorization =~ /^Basic (.*)/m
          usrname, pwd = Base64.decode64($1).split(/:/, 2)
          credentials = {:username => usrname, :password => pwd}
        end

        if resource = mapping.to.authenticate_with_unix2_chkpwd(credentials)
          Rails.logger.error "*** Success!"
          success!(resource)
        else
          Rails.logger.error "*** Invalid!"
          fail(:invalid)
        end
      end

      protected

        def valid_controller?
          params[:controller] == 'devise/sessions'
        end

        def valid_params?
          params[scope] && params[scope][:password].present?
        end

        def valid_http_auth?
          # HTTP authentication enabled and credentials present in the request
          mapping.to.http_authenticatable?(:unix2chkpwd) && request.authorization && request.authorization.match(/^Basic (.*)/)
        end
    end
  end
end

Warden::Strategies.add(:unix2_chkpwd_authenticatable, Devise::Strategies::Unix2ChkpwdAuthenticatable)

