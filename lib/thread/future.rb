#--
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#++

require 'thread/promise'

# A future is an object that incapsulates a block which is called in a
# different thread, upon retrieval the caller gets blocked until the block has
# finished running, and its result is returned and cached.
class Thread::Future
	def initialize (&block)
		Thread.new {
			begin
				deliver block.call
			rescue Exception => e
				@exception = e

				deliver nil
			end
		}
	end

	# Check if an exception has been raised.
	def exception?
		instance_variable_defined? :@exception
	end

	# Return the raised exception.
	def exception
		@exception
	end

	# Check if the future has been called.
	def delivered?
		instance_variable_defined? :@value
	end

	alias realized? delivered?

	# Get the value of the future, if it's not finished running this call will block.
	#
	# In case the block raises an exception, it will be raised, the exception is cached
	# and will be raised every time you access the value.
	def value
		raise @exception if exception?

		return @value if delivered?

		mutex.synchronize {
			cond.wait(mutex)
		}

		if exception?
			raise @exception
		else
			@value
		end
	end

	alias ~ value

	# Do the same as {#value}, but return nil in case of exception.
	def value!
		begin
			value
		rescue Exception
			nil
		end
	end

	alias ! value!

private
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
	def future (&block)
		Thread::Future.new(&block)
	end
end
