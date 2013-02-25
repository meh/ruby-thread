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

class Thread::Future < Thread::Promise
	def initialize (&block)
		@exception = false

		Thread.new {
			deliver begin
				block.call
			rescue Exception => e
				@exception = e
			end
		}
	end

	def exception?
		@exception
	end

	def exception
		@exception
	end

	def value
		value = super

		if exception?
			raise @exception
		else
			value
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
end

module Kernel
	def future (&block)
		Thread::Future.new(&block)
	end
end
