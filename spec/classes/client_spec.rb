# frozen_string_literal: true

require 'spec_helper'

describe 'snapcast::client' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
      it { is_expected.to contain_file('/etc/default/snapclient').with_owner('root') }
      it { is_expected.to contain_file('/etc/default/snapclient').with_group('root') }
      it { is_expected.to contain_file('/etc/default/snapclient').with_mode('0644') }

      describe 'package_ensure option' do
        context 'when set to present' do
          let(:params) do
            {
              package_ensure: 'present',
            }
          end

          it { is_expected.to contain_package('snapclient').with(ensure: 'present') }
        end
        context 'defaults to present' do
          it { is_expected.to contain_package('snapclient').with(ensure: 'present') }
        end
        context 'when set to absent' do
          let(:params) do
            {
              package_ensure: 'absent',
            }
          end

          it { is_expected.to contain_package('snapclient').with(ensure: 'absent') }
        end
      end
      describe 'start option' do
        context 'when set to true' do
          let(:params) do
            {
              start: 'true',
            }
          end

          it { is_expected.to contain_file('/etc/default/snapclient').with('content' => %r{^START_SNAPCLIENT=true\n}) }
        end
        context 'defaults to true' do
          it { is_expected.to contain_file('/etc/default/snapclient').with('content' => %r{^START_SNAPCLIENT=true\n}) }
        end
        context 'when set to false' do
          let(:params) do
            {
              start: 'false',
            }
          end

          it { is_expected.to contain_file('/etc/default/snapclient').with('content' => %r{^START_SNAPCLIENT=false\n}) }
        end
      end
      describe 'user_opts option' do
        context 'defaults to empty' do
          it { is_expected.to contain_file('/etc/default/snapclient').with('content' => %r{^USER_OPTS=""\n}) }
        end
        context 'when set' do
          let(:params) do
            {
              user_opts: '--user snapclient:audio',
            }
          end

          it { is_expected.to contain_file('/etc/default/snapclient').with('content' => %r{^USER_OPTS="--user snapclient:audio"\n}) }
        end
      end
      describe 'opts option' do
        context 'defaults to empty' do
          it { is_expected.to contain_file('/etc/default/snapclient').with('content' => %r{^SNAPCLIENT_OPTS=""\n}) }
        end
        context 'when set' do
          let(:params) do
            {
              opts: '-d -h my_snapserver.example.org',
            }
          end

          it { is_expected.to contain_file('/etc/default/snapclient').with('content' => %r{SNAPCLIENT_OPTS="-d -h my_snapserver\.example\.org"$}) }
        end
      end
    end
  end
end
