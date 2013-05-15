#! /usr/bin/env ruby
require 'rubygems'
require 'thread/every'

describe Thread::Every do
	it 'delivers a value properly' do
		e = Thread.every(5) { 42 }

		e.value.should == 42
	end

	it 'sees it as old properly' do
		e = Thread.every(0.8) { 42 }

		e.value.should == 42
		e.old?.should  == true

		sleep 1

		e.old?.should == false
		e.value.should == 42
		e.old?.should == true
	end
end
