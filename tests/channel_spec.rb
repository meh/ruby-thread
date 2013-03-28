#! /usr/bin/env ruby
require 'rubygems'
require 'thread/channel'

describe Thread::Channel do
	it 'receives in the proper order' do
		ch = Thread.channel
		ch.send 'lol'
		ch.send 'wut'

		ch.receive.should == 'lol'
		ch.receive.should == 'wut'
	end

	it 'receives with constraints properly' do
		ch = Thread.channel
		ch.send 'lol'
		ch.send 'wut'

		ch.receive { |v| v == 'wut' }.should == 'wut'
		ch.receive.should == 'lol'
	end

	it 'receives nil when using non blocking mode and the channel is empty' do
		ch = Thread.channel

		ch.receive!.should == nil
	end

	it 'guards sending properly' do
		ch = Thread.channel { |v| v.is_a? Integer }

		expect {
			ch.send 23
		}.to_not raise_error

		expect {
			ch.send 'lol'
		}.to raise_error
	end
end
