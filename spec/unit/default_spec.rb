require 'spec_helper'

describe 'rackspace_holland::default' do
  context 'Ubuntu 12.04' do
    let(:chef_run) { ChefSpec::Runner.new(platform: 'ubuntu', version: '12.04').converge(described_recipe) }

    it 'installs the python-support package' do
      expect(chef_run).to install_package('python-support')
    end

    it 'installs the python-pkg-resources package' do
      expect(chef_run).to install_package('python-pkg-resources')
    end

    it 'downloads the holland package if missing' do
      expect(chef_run).to create_remote_file_if_missing(Chef::Config['file_cache_path'] + '/ubuntu1204-holland_1.0.10-1_all.deb')
    end

    it 'installs the holland package' do
      expect(chef_run).to install_package('holland')
    end
  end

  context 'Debian 7' do
    let(:chef_run) { ChefSpec::Runner.new(platform: 'debian', version: '7.2').converge(described_recipe) }

    it 'installs the python-support package' do
      expect(chef_run).to install_package('python-support')
    end

    it 'installs the python-pkg-resources package' do
      expect(chef_run).to install_package('python-pkg-resources')
    end

    it 'downloads the holland package if missing' do
      expect(chef_run).to create_remote_file_if_missing(Chef::Config['file_cache_path'] + '/debian72-holland_1.0.10-1_all.deb')
    end

    it 'installs the holland package' do
      expect(chef_run).to install_package('holland')
    end
  end

  context 'CentOS 6' do
    let(:chef_run) { ChefSpec::Runner.new(platform: 'centos', version: '6.4').converge(described_recipe) }

    it 'installs the python-setuptools package' do
      expect(chef_run).to install_package('python-setuptools')
    end

    it 'installs the holland package' do
      expect(chef_run).to install_package('holland')
    end
  end

  context 'RedHat 6' do
    let(:chef_run) { ChefSpec::Runner.new(platform: 'redhat', version: '6.3').converge(described_recipe) }

    it 'installs the python-setuptools package' do
      expect(chef_run).to install_package('python-setuptools')
    end

    it 'installs the holland package' do
      expect(chef_run).to install_package('holland')
    end
  end
end
