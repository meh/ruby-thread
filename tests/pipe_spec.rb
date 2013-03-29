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

	it 'empty works properly' do
		p = Thread |-> d { sleep 0.2; d * 2 } |-> d { d * 4 }

		p.empty?.should == true
		p.enq 42
		p.empty?.should == false
		p.deq
		p.empty?.should == true
	end
end
