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

# A pipe lets you execute various tasks on a set of data in parallel,
# each datum inserted in the pipe is passed along through queues to the various
# functions composing the pipe, the final result is inserted in the final queue.
class Thread::Pipe
	class Task
		attr_accessor :input, :output

		def initialize (func, input = Queue.new, output = Queue.new)
			@input  = input
			@output = output

			@thread = Thread.new {
				while true
					begin
						value = @input.deq
						value = func.call(value)

						@output.enq value
					rescue Exception; end
				end
			}
		end

		def kill
			@thread.raise
		end
	end

	# Create a pipe using the optionally passed objects as input and
	# output queue.
	#
	# The objects must respond to #enq and #deq, and block on #deq.
	def initialize (input = Queue.new, output = Queue.new)
		@tasks = []

		@input  = input
		@output = output

		ObjectSpace.define_finalizer(self, self.class.finalize(@tasks))
	end

	def self.finalize (tasks)
		proc {
			tasks.each(&:kill)
		}
	end

	# Insert data in the pipe.
	def << (data)
		return if @tasks.empty?

		@input.enq data

		self
	end

	# Add a task to the pipe, it must respond to #call and #arity,
	# and #arity must return 1.
	def | (func)
		if func.arity != 1
			raise ArgumentError, 'wrong arity'
		end

		Task.new(func, (@tasks.empty? ? @input : Queue.new), @output).tap {|t|
			@tasks.last.output = t.input unless @tasks.empty?
			@tasks << t
		}

		self
	end

	# Get an element from the output queue.
	def pop (non_block = false)
		@output.deq(non_block)
	end
	
	alias deq pop
	alias ~   pop
end
