require "oauth/ok/version"

module Oauth
	module Ok
		#
		# Class for OAuth 2.0 on http://odnoklassniki.ru/
		#
		class OkAuth
			require 'net/http'

			@options                                                # array aplication options
			@@auth_url_options = {
				'auth_host'         => "www.odnoklassniki.ru",      # domain service
				'auth_page'         => "/oauth/authorize",          # auth page
				'api_host'          => "api.odnoklassniki.ru",      # domain API service
				'access_token_path' => "/oauth/token.do",           # page for getting access token
				'method_url_path'   => "/fb.do"                     # page for request api methods
			}


			#
			# Class constructor
			#
			# auth_options - array aplication options
			#
			# return string
			#
			def initialize(auth_options)
				@options = OkAuth.getUrlOptions
				@options = @options.merge(auth_options)
			end


			#
			# Getting auth params
			#
			# return array
			#
			def OkAuth.getUrlOptions
				@@auth_url_options
			end


			#
			# Getting user auth URL
			#
			# return string
			#
			def getAuthUrl
				URI::HTTP.build(
					:host  => @options['auth_host'],
					:path  => @options['auth_page'],
					:query => {
						:client_id     => @options['client_id'],
						:scope         => @options['scope'],
						:response_type => "code",
						:redirect_uri  => @options['redirect_uri'],
					}.to_query
				).to_s
			end


			#
			# Getting SIG for request method "users.getCurrentUser"
			#
			# access_token - string access token for requests api methods
			#
			# return string
			#
			def getSig(access_token)
				methodStr = 'application_key=' + @options['application_key'] + 'method=users.getCurrentUser'
				Digest::MD5.hexdigest(methodStr + Digest::MD5.hexdigest(access_token + @options['client_secret']))
			end


			#
			# Gettion user data
			#
			# code - string access code for getting user info
			#
			# return array
			#
			def getUserData(code)
				accessUri = URI::HTTP.build(
					:host  => @options['api_host'],
					:path  => @options['access_token_path'],
					:query => {
						:code          => code,
						:redirect_uri  => @options['redirect_uri'],
						:grant_type    => "authorization_code",
						:client_id     => @options['client_id'],
						:client_secret => @options['client_secret'],
					}.to_query
				)

				accessRequest = JSON.parse Net::HTTP.post_form(accessUri, []).body

				getCurrentUserUri = URI::HTTP.build(
					:host  => @options['api_host'],
					:path  => @options["method_url_path"],
					:query => {
						:access_token    => accessRequest['access_token'],
						:application_key => @options['application_key'],
						:method          => "users.getCurrentUser",
						:sig             => self.getSig(accessRequest['access_token'])
					}.to_query
				)

				JSON.parse Net::HTTP.get_response(getCurrentUserUri).body
			end


			public    :getAuthUrl, :getUserData
			protected :getSig

		end
	end
end
