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
