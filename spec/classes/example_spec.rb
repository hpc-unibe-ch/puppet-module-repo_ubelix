require 'spec_helper'

describe 'ubelixrepo' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "ubelixrepo class without any parameters on #{osfamily}" do
          let(:params) {{ }}

          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('ubelixrepo::params') }
          it { is_expected.to contain_class('ubelixrepo::install').that_comes_before('ubelixrepo::config') }
          it { is_expected.to contain_class('ubelixrepo::config') }
          it { is_expected.to contain_class('ubelixrepo::service').that_subscribes_to('ubelixrepo::config') }

          it { is_expected.to contain_service('ubelixrepo') }
          it { is_expected.to contain_package('ubelixrepo').with_ensure('present') }
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'ubelixrepo class without any parameters on Solaris/Nexenta' do
      let(:facts) {{
        :osfamily        => 'Solaris',
        :operatingsystem => 'Nexenta',
      }}

      it { expect { is_expected.to contain_package('ubelixrepo') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end

