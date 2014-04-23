require_relative "../spec_helper"

describe "zookeeperd::client" do

  let(:runner)    { ChefSpec::Runner.new }
  let(:node)      { runner.node}
  let(:chef_run)  { runner.converge(described_recipe) }

  shared_examples "installing a client" do

    it "installs a default zookeeper client package" do
      expect(chef_run).to install_package(default_client_pkg)
    end

    it "installs custom packages if set" do
      node.set[:zookeeperd][:client_packages] = %w{foo bar}

      expect(chef_run).to install_package("foo")
      expect(chef_run).to install_package("bar")
    end
  end

  context "on ubuntu-12.04" do

    let(:runner) { ChefSpec::Runner.new(platform: "ubuntu", version: "12.04") }
    let(:default_client_pkg) { "zookeeper" }

    context "using system packages" do

      include_examples "installing a client"

      it "doesn't include the java recipe" do
        expect(chef_run).to_not include_recipe("java")
      end

      it "doesn't include the zookeeperd::cloudera_repo" do
        expect(chef_run).to_not include_recipe("zookeeperd::cloudera_repo")
      end
    end

    context "with cloudera packages" do

      before { node.set[:zookeeperd][:cloudera_repo] = true }

      include_examples "installing a client"

      it "includes the java recipe" do
        expect(chef_run).to include_recipe("java")
      end

      it "includes the zookeeperd::cloudera_repo" do
        expect(chef_run).to include_recipe("zookeeperd::cloudera_repo")
      end
    end
  end
end
