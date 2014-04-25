require 'thread/every'

describe Thread::Every do
	it 'delivers a value properly' do
		e = Thread.every(5) { sleep 0.02; 42 }

		e.value.should == 42
	end
end
