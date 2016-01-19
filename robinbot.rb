#!/usr/bin/env ruby
require 'slack-ruby-bot'
require 'open-uri'

SlackRubyBot.configure do |config|
  config.send_gifs = false
end

class RobinBot < SlackRubyBot::Bot
  match 'robinbot' do |c, d, m|
    logger.info "getting: 'http://robinbot.co.uk'"
    doc = open('http://robinbot.co.uk',&:read)
    c.say(text: "```#{doc}```", channel: d.channel)
  end

  match(/robinbot (?<key>[a-zA-Z0-9]+(\-[a-zA-Z0-9]+)+)/) do |c, d, m|
    logger.info "getting: 'http://robinbot.co.uk/#{m[:key]}'"
    doc = open("http://robinbot.co.uk/#{m[:key]}",&:read)
    c.say(text: "```#{doc}```", channel: d.channel)
  end

  command 'list' do |c, d, m|
    logger.info "getting: 'http://robinbot.co.uk/list'"
    doc = open('http://robinbot.co.uk/list',&:read)
    list = doc.scan(/(?<key>.*)=>(?<quote>.*)/)
    c.say(text: list.map{|k,v| "#{k.strip}: #{v.strip}"}, channel: d.channel)
  end

  command 'count' do |c, d, m|
    logger.info "getting: 'http://robinbot.co.uk/list'"
    doc = open('http://robinbot.co.uk/list',&:read)
    list = doc.scan(/(?<key>.*)=>(?<quote>.*)/)
    c.say(text: "I have #{list.size} quotes in my DB", channel: d.channel)
  end
  
  match(/robinbot (?<term>.*)/) do |c,d,m|
    logger.info "getting list: 'http://robinbot.co.uk/list'"
    doc = open('http://robinbot.co.uk/list',&:read)
    list = doc.scan(/(?<key>.*)=>(?<quote>.*)/)
    logger.info "Looking for records containing: '#{m[:term]}'"
    key,quote = list.find{|k,q| q.include? m[:term] }
    logger.info "Key = '#{key}' {#{key.inspect}}"
    out = ''
    if key.nil?
      out = "Sorry, Could not find quote containing \"#{m[:term]}\""
    else
      logger.info  "getting quote 'http://robinbot.co.uk/#{key.strip}'"
      quote = open("http://robinbot.co.uk/#{key.strip}",&:read)
      out = "```#{quote}```"
    end
    c.say(text: out, channel: d.channel)
  end

end

RobinBot.run
