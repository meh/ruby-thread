#--
#           DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                   Version 2, December 2004
#
#           DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#  TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#++

require 'thread'

# A recursive mutex lets you lock in various threads recursively, allowing
# you to do multiple locks one inside another.
#
# You really shouldn't use this, but in some cases it makes your life easier.
class RecursiveMutex < Mutex
	def initialize
		@threads = Hash.new { |h, k| h[k] = 0 }

		super
	end

	# Lock the mutex.
	def lock
		@thread[Thread.current] += 1

		if @thread[Thread.current] == 1
			super
		end
	end

	# Unlock the mutex.
	def unlock
		@thread[Thread.current] -= 1

		if @thread[Thread.current] == 0
			@thread.delete(Thread.current)

			super
		end
	end
end
