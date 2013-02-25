#--
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#++

class Thread::Delay
	def initialize (&block)
		@block = block
	end

	def exception?
		instance_variable_defined? :@exception
	end

	def delivered?
		instance_variable_defined? :@value
	end

	alias realized? delivered?

	def value
		raise @exception if exception?

		return @value if realized?

		begin
			@value = @block.call
		rescue Exception => e
			@exception = e

			raise
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
	def delay (&block)
		Thread::Delay.new(&block)
	end
end
