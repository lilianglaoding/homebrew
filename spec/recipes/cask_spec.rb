require_relative '../spec_helper'

describe 'homebrew::cask' do
  context 'default user' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'mac_os_x', version: '10.11.1').converge(described_recipe)
    end

    before(:each) do
      allow_any_instance_of(Chef::Resource).to receive(:homebrew_owner).and_return('vagrant')
    end

    it 'manages the Cask Cache directory' do
      allow(Dir).to receive(:exist?).with('/Library/Caches/Homebrew').and_return(true)
      expect(chef_run).to create_directory('/Library/Caches/Homebrew/Casks').with(
        user: 'vagrant',
        mode: 00775
      )
    end
  end

  context 'non-default, specified by attribute user' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'mac_os_x', version: '10.11.1') do |node|
        node.set['homebrew']['owner'] = 'alaska'
      end.converge(described_recipe)
    end

    it 'manages the Cask Cache directory' do
      allow(Dir).to receive(:exist?).with('/Library/Caches/Homebrew').and_return(true)
      expect(chef_run).to create_directory('/Library/Caches/Homebrew/Casks').with(
        user: 'alaska',
        mode: 00775
      )
    end
  end
end
