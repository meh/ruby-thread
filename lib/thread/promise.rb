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
	# Check if a value has been delivered.
	def delivered?
		instance_variable_defined? :@value
	end

	alias realized? delivered?

	# Deliver a value.
	def deliver (value)
		return if delivered?

		@value = value

		if cond?
			mutex.synchronize {
				cond.broadcast
			}
		end

		self
	end

	alias << deliver

	# Get the value that's been delivered, if none has been delivered yet the call
	# will block until one is delivered.
	def value
		return @value if delivered?

		mutex.synchronize {
			cond.wait(mutex)
		}

		@value
	end

	alias ~ value

private
	def cond?
		instance_variable_defined? :@cond
	end

	def cond
		@cond ||= ConditionVariable.new
	end

	def mutex
		@mutex ||= Mutex.new
	end
end

module Kernel
	def promise
		Thread::Promise.new
	end
end
