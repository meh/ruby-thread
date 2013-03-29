#! /usr/bin/env ruby
require 'rubygems'
require 'thread/pipe'

describe Thread::Pipe do
	it 'handles passing properly' do
		p = Thread |-> d { d * 2 } |-> d { d * 4 }

		p << 2
		p << 4

		p.deq.should == 16
		p.deq.should == 32
	end
end
