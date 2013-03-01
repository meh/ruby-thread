#--
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#++

require 'thread'

# A promise is an object that lets you wait for a value to be delivered to it.
class Thread::Promise
	# Create a promise.
	def initialize
		@mutex = Mutex.new
		@cond  = ConditionVariable.new
	end

	# Check if a value has been delivered.
	def delivered?
		@mutex.synchronize {
			instance_variable_defined? :@value
		}
	end

	alias realized? delivered?

	# Deliver a value.
	def deliver (value)
		return if delivered?

		@mutex.synchronize {
			@value = value
			@cond.broadcast
		}

		self
	end

	alias << deliver

	# Get the value that's been delivered, if none has been delivered yet the call
	# will block until one is delivered.
	def value (timeout = nil)
		return @value if delivered?

		@mutex.synchronize {
			@cond.wait(@mutex, *timeout)
		}

		return @value if delivered?
	end

	alias ~ value
end

module Kernel
	def promise
		Thread::Promise.new
	end
end
