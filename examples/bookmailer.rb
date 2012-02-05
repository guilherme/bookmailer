require_relative "../lib/bookmailer"

Newman::Server.simple(Bookmailer::Application, "config/environment.rb")

