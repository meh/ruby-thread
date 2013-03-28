#! /usr/bin/env ruby
require 'rubygems'
require 'thread/delay'

describe Thread::Delay do
	it 'delivers a value properly' do
		d = Thread.delay {
			42
		}

		d.value.should == 42
	end
end
