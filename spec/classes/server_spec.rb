require 'spec_helper'

describe 'puppet::server', :type => :class do
  context 'on Ubuntu 12.04 (Precise)' do
    let(:facts) { { 
      :lsbdistcodename  => 'precise',
      :lsbdistrelease   => '12.04',
      :operatingsystem  => 'Ubuntu',
    } }

    let(:params) { {
      :monitor  => false,
      :options  => {
        'dbadapter'   => 'sqlite3',
        'dbpassword'  => 'secret',
      },
    } }

    it do
      should_not contain_class('puppet::server::monitor')
    end

    directories = [
      '/etc/puppet',
      '/etc/puppet/modules',
      '/etc/puppet/manifests',
      '/etc/puppet/templates',
    ]

    directories.each do |dirs|
      it do
        should contain_file(dirs).with({
          'ensure'  => 'directory',
          'group'   => 'root',
          'mode'    => '0644',
          'owner'   => 'root',
        })
      end
    end

    it do
      should contain_file('/etc/puppet/puppet.conf').with({
        'group'   => 'root',
        'mode'    => '0644',
        'owner'   => 'root',
      })
    end

    packages = [
      'puppetmaster-passenger',
      'ruby-activerecord',
      'ruby-mysql',
    ]
    packages.each do |p|
      it do
        should contain_package(p).with_ensure('present')
      end
    end
  end
end

# vim:sw=2:ts=2:expandtab:textwidth=79