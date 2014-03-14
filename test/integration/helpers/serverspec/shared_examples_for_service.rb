shared_examples "a zookeeper service" do

  it "is listening on a custom port" do
    expect(port(9000)).to be_listening
  end

  it "has a running service with a name containing zookeeper" do
    expect(service("zookeeper")).to be_running
  end

  it "only runs one java process (no zombies)" do
    javas = command("ps -ef").stdout.split("\n").select { |p| p =~ /java/ }

    expect(javas.count).to eq(1)
  end
end
