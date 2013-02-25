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

class Thread::Future
	def initialize (&block)
		@exception = false

		Thread.new {
			begin
				deliver block.call
			rescue Exception => e
				@exception = e

				deliver nil
			end
		}
	end

	def exception?
		!!@exception
	end

	def exception
		@exception
	end

	def delivered?
		instance_variable_defined? :@value
	end

	alias realized? delivered?

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
