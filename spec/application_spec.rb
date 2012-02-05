require 'minitest/autorun'
require_relative 'spec_helper'


describe "Bookmailer::Application" do

  before do
    @server = ::Newman::Server
    @server.test_mode("config/test.rb")
    @mailer = @server.mailer
  end

  it "should add/retrieve/delete bookmarks" do
    @mailer.deliver_message(:from => "tester@test.com",
                           :to   => "test+put@test.com",
                           :subject => "mendicant http://mendicantuniversity.org",
                           :body => "An awesome place to learn")

    @server.tick(Bookmailer::Application)
    @mailer.messages.first.subject.must_equal("Bookmark saved mendicant")


    @mailer.deliver_message(:from => "tester@test.com",
                           :to   => "test+get@test.com",
                           :subject => "mendicant")
    @server.tick(Bookmailer::Application)
    messages = @mailer.messages
    messages.first.subject.must_equal("Bookmark: mendicant")
    assert_match /http:\/\/mendicantuniversity\.org/, messages.first.body.to_s
    assert_match /An awesome place to learn/, messages.first.body.to_s

    @mailer.deliver_message(:from => "tester@test.com",
                           :to   => "test+delete@test.com",
                           :subject => "mendicant")

    @server.tick(Bookmailer::Application)
    @mailer.messages.first.subject.must_equal("Bookmark removed mendicant")


    @mailer.deliver_message(:from => "tester@test.com",
                           :to   => "test+get@test.com",
                           :subject => "mendicant")
    @server.tick(Bookmailer::Application)
    @mailer.messages.first.subject.must_equal("Bookmark not found")

  end

  after do
    if File.exists?(@server.settings.application.bookmailer_db)
      File.unlink(@server.settings.application.bookmailer_db)
    end
  end

end
