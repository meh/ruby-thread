thread - various extensions to the thread stdlib
================================================

Pool
====
All the implementations I looked at were either buggy or wasted CPU resources
for no apparent reason, for example used a sleep of 0.01 seconds to then check for
readiness and stuff like this.

This implementation uses standard locking functions to work properly across multiple Ruby
implementations.

Example
-------

```ruby
require 'thread/pool'

pool = Thread::Pool.new(4)

10.times {
  pool.process {
    sleep 2

    puts 'lol'
  }
}

pool.shutdown
```

You should get 4 lols every 2 seconds and it should exit after 10 of them.

Channel
=======
This implements a channel where you can write messages and receive messages.

Example
-------

```ruby
require 'thread/channel'

channel = Thread::Channel.new
channel.send 'wat'
channel.receive # => 'wat'

channel = Thread::Channel.new { |o| o.is_a?(Integer) }
channel.send 'wat' # => ArgumentError: guard mismatch

Thread.new {
  while num = channel.receive(&:even?)
    puts 'Aye!'
  end
}

Thread.new {
  while num = channel.receive(&:odd?)
    puts 'Arrr!'
  end
}

loop {
  channel.send rand(1_000_000_000)

  sleep 0.5
}
```

Promise
=======
This implements the promise pattern, allowing you to pass around an object
where you can send a value and extract a value, in a thread-safe way, accessing
the value will wait for the value to be delivered.

Example
-------

```ruby
require 'thread/promise'

p = promise

Thread.new {
  sleep 5
  p << 42
}

puts ~p # => 42
```

Future
======
A future is somewhat a promise, except you pass it a block to execute in
another thread.

The value returned by the block will be the value of the promise.

Example
-------

```ruby
require 'thread/future'

puts ~future {
  sleep 5

  42
} # => 42
```

Delay
=====
A delay is kind of a promise, except the block is called when the value is
being accessed and the result is cached.

Example
-------

```ruby
require 'thread/delay'

puts ~delay {
  42
}
```
