require 'spec_helper'

describe 'ubelixrepo' do
  context 'supported operating systems' do
    ['Debian', 'RedHat'].each do |osfamily|
      describe "ubelixrepo class without any parameters on #{osfamily}" do
        let(:params) {{ }}
        let(:facts) {{
          :osfamily => osfamily,
        }}

        it { should compile.with_all_deps }

        it { should contain_class('ubelixrepo::params') }
        it { should contain_class('ubelixrepo::install').that_comes_before('ubelixrepo::config') }
        it { should contain_class('ubelixrepo::config') }
        it { should contain_class('ubelixrepo::service').that_subscribes_to('ubelixrepo::config') }

        it { should contain_service('ubelixrepo') }
        it { should contain_package('ubelixrepo').with_ensure('present') }
      end
    end
  end

  context 'unsupported operating system' do
    describe 'ubelixrepo class without any parameters on Solaris/Nexenta' do
      let(:facts) {{
        :osfamily        => 'Solaris',
        :operatingsystem => 'Nexenta',
      }}

      it { expect { should contain_package('ubelixrepo') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
