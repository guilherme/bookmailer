require "newman"

$:.unshift File.expand_path('..',__FILE__)

module Bookmailer

  autoload :Application, 'bookmailer/application'
  autoload :BookmarkRepository, 'bookmailer/bookmark_repository'
end
