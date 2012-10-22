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

class Thread::Channel
	def initialize (messages = [], &block)
		@messages = []
		@mutex    = Mutex.new
		@cond     = ConditionVariable.new
		@check    = block

		messages.each {|o|
			send o
		}
	end

	def send (what)
		if @check && !@check.call(what)
			raise ArgumentError, 'guard mismatch'
		end

		@mutex.synchronize {
			@messages << what
			@cond.broadcast
		}

		self
	end

	def receive (&block)
		message = nil

		if block
			found = false

			until found
				@mutex.synchronize {
					if index = @messages.find_index(&block)
						message = @messages.delete_at(index)
						found   = true
					else
						@cond.wait @mutex
					end
				}
			end
		else
			@mutex.synchronize {
				if @messages.empty?
					@cond.wait @mutex
				end

				message = @messages.shift
			}
		end

		message
	end

	def receive! (&block)
		if block
			@messages.delete_at(@messages.find_index(&block))
		else
			@messages.shift
		end
	end
end
