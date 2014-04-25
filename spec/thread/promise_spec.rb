require 'thread/promise'

describe Thread::Promise do
	it 'delivers a value properly' do
		p = Thread.promise

		Thread.new {
			sleep 0.02

			p << 42
		}

		p.value.should == 42
	end

	it 'properly checks if anything has been delivered' do
		p = Thread.promise

		Thread.new {
			sleep 0.02

			p << 42
		}

		p.delivered?.should == false
		sleep 0.03
		p.delivered?.should == true
	end

	it 'does not block when a timeout is passed' do
		p = Thread.promise

		p.value(0).should == nil
	end
end
