require 'spec_helper'

describe 'repo_ubelix' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "repo_ubelix class without any parameters on #{osfamily}" do
          let(:params) {{ }}

          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('repo_ubelix::params') }
          it { is_expected.to contain_class('repo_ubelix::install').that_comes_before('repo_ubelix::config') }
          it { is_expected.to contain_class('repo_ubelix::config') }
          it { is_expected.to contain_class('repo_ubelix::service').that_subscribes_to('repo_ubelix::config') }

          it { is_expected.to contain_service('repo_ubelix') }
          it { is_expected.to contain_package('repo_ubelix').with_ensure('present') }
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'repo_ubelix class without any parameters on Solaris/Nexenta' do
      let(:facts) {{
        :osfamily        => 'Solaris',
        :operatingsystem => 'Nexenta',
      }}

      it { expect { is_expected.to contain_package('repo_ubelix') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end

