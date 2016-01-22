require_relative '../spec_helper'

describe 'zookeeperd::server' do
  let(:runner)    { ChefSpec::Runner.new }
  let(:node)      { runner.node }
  let(:chef_run)  { runner.converge(described_recipe) }

  before do
    node.set['zookeeperd']['cluster']['auto_discovery'] = false
    node.set['zookeeperd']['zk_id'] = 99
  end

  shared_examples 'installing a server' do
    it 'has a pre-package hook resource' do
      expect(chef_run).to write_log('zookeeperd pre-package hook')
    end

    it 'includes the zookeeperd::client recipe' do
      expect(chef_run).to include_recipe('zookeeperd::client')
    end

    it 'installs a default package zookeeper package' do
      expect(chef_run).to install_package(default_server_pkg)
    end

    it 'installs custom packages if set' do
      node.set['zookeeperd']['server_packages'] = %w(foo bar)

      expect(chef_run).to install_package('foo')
      expect(chef_run).to install_package('bar')
    end

    it 'creates zoo.cfg from a template' do
      file = '/etc/zookeeper/conf/zoo.cfg'

      expect(chef_run).to create_template(file).with(
        source: 'zoo.cfg.erb',
        mode: 0644
      )
      expect(chef_run).to render_file(file).with_content(
        regexify_line('clientPort=2181')
      )
    end

    it 'creates log4j.properties from a template' do
      file = '/etc/zookeeper/conf/log4j.properties'

      expect(chef_run).to create_template(file).with(
        source: 'log4j.properties.erb',
        mode: 0644
      )
      expect(chef_run).to render_file(file).with_content(
        regexify_line('log4j.appender.CONSOLE.Threshold=INFO')
      )
    end

    it 'creates the myid file' do
      expect(chef_run).to render_file('/etc/zookeeper/conf/myid').with_content("99\n")
    end

    it 'enables a service' do
      expect(chef_run).to enable_service('zookeeper').with(
        service_name: service_name
      )
    end

    it 'starts a service' do
      expect(chef_run).to enable_service('zookeeper').with(
        service_name: service_name
      )
    end

    it 'marks the node as a zookeeper node' do
      expect(chef_run).to run_ruby_block('mark as a zookeeper node')
    end
  end

  shared_examples 'using cloudera repo' do
    before { node.set['zookeeperd']['cloudera_repo'] = true }

    it 'includes the java recipe' do
      expect(chef_run).to include_recipe('java')
    end

    it 'includes the zookeeperd::cloudera_repo recipe' do
      expect(chef_run).to include_recipe('zookeeperd::cloudera_repo')
    end

    it 'executes a zookeeper initialize' do
      resource = chef_run.execute('zk_init')

      expect(resource.command).to eq('/usr/bin/zookeeper-server-initialize')
      expect(resource.user).to eq('zookeeper')
      expect(resource.group).to eq('zookeeper')
    end
  end

  context 'on ubuntu-12.04' do
    let(:runner) { ChefSpec::Runner.new(platform: 'ubuntu', version: '12.04') }

    context 'using system packages' do
      let(:default_server_pkg) { 'zookeeperd' }
      let(:service_name) { 'zookeeper' }

      include_examples 'installing a server'

      it "doesn't include the java recipe" do
        expect(chef_run).to_not include_recipe('java')
      end

      it "doesn't include the zookeeperd::cloudera_repo recipe" do
        expect(chef_run).to_not include_recipe('zookeeperd::cloudera_repo')
      end
    end

    context 'with cloudera packages' do
      let(:default_server_pkg) { 'zookeeper-server' }
      let(:service_name) { 'zookeeper-server' }

      include_examples 'installing a server'
      include_examples 'using cloudera repo'
    end
  end

  context 'on centos-6.4' do
    let(:runner) { ChefSpec::Runner.new(platform: 'centos', version: '6.4') }

    context 'with cloudera packages' do
      let(:default_server_pkg) { 'zookeeper-server' }
      let(:service_name) { 'zookeeper-server' }

      include_examples 'installing a server'
      include_examples 'using cloudera repo'
    end
  end

  def regexify_line(string)
    Regexp.new("^#{Regexp.escape(string)}$")
  end
end
