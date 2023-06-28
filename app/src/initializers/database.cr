require "kemal"
require "jennifer"
require "jennifer/adapter/postgres"

PG_PATH = ENV["PG_PATH"]
DB_NAME = ENV["DB_NAME"]

Jennifer::Config.configure do |conf|
  conf.from_uri("#{PG_PATH}/#{DB_NAME}")
  conf.logger.level = Log::Severity::Debug
  conf.adapter = "postgres"
  conf.pool_size = ("5").to_i
end
