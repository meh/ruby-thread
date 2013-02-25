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
		Thread.new {
			deliver block.call
		}
	end
end

module Kernel
	def future (&block)
		Thread::Future.new(&block)
	end
end
