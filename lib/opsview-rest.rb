# Carlos Gomez
# blog.carlosgomez.net
# Opsview API call

require 'httparty'
require 'yaml'
require 'xml-fu'
require 'pp'
require 'json'

class Opsapi
	include HTTParty
	format :xml

	def initialize(file_path="config-ops.yml")
		raise "no file #{file_path}" unless File.exists? file_path
		configuration = YAML.load_file(file_path)
		$username =  "#{configuration[:username]}"		
		$postdata = "{\"username\":\"#{$username}\",\"password\":\"#{configuration[:password]}\"}"	
		self.class.base_uri configuration[:site]
		self.class.default_options[:headers] = {"Accept" => "application/json", "Content-type" => "application/json"}
	end
	def login
		puts "Logging in ...\n\n"
	    puts $postdata
		response = self.class.post("/rest/login", :body => $postdata)
		@json = JSON.parse(response.body)		
		@token = @json["token"]
		puts @token
		self.class.default_options[:headers] = {"Accept" => "application/json","Content-type" => "application/json", "X-Opsview-Username" => $username, "X-Opsview-Token" => @token}
	end
	def info
	    response = self.class.get("/rest/info")
		@json = JSON.parse(response.body)	
	end
	def listcontact
	    response = self.class.get("/rest/config/contact")
		@json = JSON.parse(response.body)	
	end
end