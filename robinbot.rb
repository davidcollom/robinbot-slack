#!/usr/bin/env ruby
require 'slack-ruby-bot'
require 'open-uri'

SlackRubyBot.configure do |config|
  config.send_gifs = false
end

class RobinBot < SlackRubyBot::Bot
  match 'robinbot' do |c, d, m|
    doc = open('http://robinbot.co.uk',&:read)
    c.say(text: "```#{doc}```", channel: d.channel)
  end

  match(/robinbot (?<key>([a-z-A-Z0-9]+(\-?)))/) do |c, d, m|
    doc = open("http://robinbot.co.uk/#{m[:key]}",&:read)
    c.say(text: "```#{doc}```", channel: d.channel)
  end

  command 'list' do |c, d, m|
    doc = open('http://robinbot.co.uk/list',&:read)
    list = doc.scan(/(?<key>.*)=>(?<quote>.*)/)
    c.say(text: list.map{|k,v| "#{k.strip}: #{v.strip}"}, channel: d.channel)
  end

  command 'count' do |c, d, m|
    doc = open('http://robinbot.co.uk/list',&:read)
    list = doc.scan(/(?<key>.*)=>(?<quote>.*)/)
    c.say(text: "I have #{list.size} quotes in my DB", channel: d.channel)
  end
  
  match(/robinbot (?<term>.*)/) do |c,d,m|
    puts "getting quote: http://robinbot.co.uk/list"
    doc = open('http://robinbot.co.uk/list',&:read)
    list = doc.scan(/(?<key>.*)=>(?<quote>.*)/)
    key,quote = list.find{|k,q| q.include? m[:term] }
    if key.nil?
      c.say(text: "Sorry, Could not find quote containing \"#{m[:term]}\"", channel: d.channel)
    else
      puts "getting quote: http://robinbot.co.uk/#{key.strip}"
      quote = open("http://robinbot.co.uk/#{key.strip}",&:read)
      c.say(text: "```#{quote}```", channel: d.channel)
    end
  end

end

RobinBot.run
