require 'rubygems'
require 'sinatra'
require 'dm-core'
require 'dm-validations'
require 'maruku'

# Database connection
DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/test.db")

require 'page'
require 'helpers'

DataMapper.auto_upgrade!

# App Settings
SITE_NAME = "Milkshake"

enable :sessions 

helpers do
def admin?
  session[:admin]
end
 
def authorise
  stop [ 401, 'You do not have permission to see this page.' ] unless admin?
end
end