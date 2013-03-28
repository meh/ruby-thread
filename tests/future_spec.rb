#! /usr/bin/env ruby
require 'rubygems'
require 'thread/future'

describe Thread::Future do
	it 'delivers a value properly' do
		f = Thread.future {
			sleep 0.2
			
			42
		}

		f.value.should == 42
	end

	it 'properly checks if anything has been delivered' do
		f = Thread.future {
			sleep 0.2

			42
		}

		f.delivered?.should == false
		sleep 0.3
		f.delivered?.should == true
	end

	it 'does not block when a timeout is passed' do
		f = Thread.future {
			sleep 0.2

			42
		}

		f.value(0).should == nil
	end
end
