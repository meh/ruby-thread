require 'thread/pool'

describe Thread::Pool do
  let(:threads) { 4 }
  let(:pool)    { Thread.pool(threads) }
  let(:workers) { pool.instance_variable_get(:"@workers") }
  
  it "has alive threads" do
    loop { break if workers.none? { |w| w.status == "run" } }
    expect(workers.all? { |w| w.alive? }).to be_truthy
  end
end
