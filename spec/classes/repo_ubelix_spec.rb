require 'spec_helper'

describe 'repo_ubelix' do
  on_supported_os(facterversion: '2.4').each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      # Testing if class defaults are used.
      context 'with class defaults' do
        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_class('repo_ubelix') }
        it { is_expected.to contain_yumrepo('ubelix').without_baseurl }
      end
    end
  end
end
