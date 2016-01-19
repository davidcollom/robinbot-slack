#!/usr/bin/env ruby
require 'slack-ruby-bot'
require 'open-uri'

SlackRubyBot.configure do |config|
  config.send_gifs = false
end

class RobinBot < SlackRubyBot::Bot
  match 'robinbot' do |client, data, match|
    doc = open('http://robinbot.co.uk',&:read)
    client.say(text: "```#{doc}```", channel: data.channel)
  end

  match(/robinbot (?<key>([a-z-A-Z0-9]+(\-?)))/) do |client, data, match|
    doc = open("http://robinbot.co.uk/#{match[:key]}",&:read)
    client.say(text: "```#{doc}```", channel: data.channel)
  end

  command 'list' do |client, data, match|
    doc = open('http://robinbot.co.uk/list',&:read)
    list = doc.scan(/(?<key>.*)=>(?<quote>.*)/)
    client.say(text: list.map{|k,v| "#{k.strip}: #{v.strip}"}, channel: data.channel)
  end

  command 'count' do |client, data, match|
    doc = open('http://robinbot.co.uk/list',&:read)
    list = doc.scan(/(?<key>.*)=>(?<quote>.*)/)
    client.say(text: "I have #{list.size} quotes in my DB", channel: data.channel)
  end

end

RobinBot.run
