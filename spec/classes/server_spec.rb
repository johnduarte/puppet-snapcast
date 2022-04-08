# frozen_string_literal: true

require 'spec_helper'

describe 'snapcast::server' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
      it { is_expected.to contain_file('/etc/default/snapserver').with_owner('root') }
      it { is_expected.to contain_file('/etc/default/snapserver').with_group('root') }
      it { is_expected.to contain_file('/etc/default/snapserver').with_mode('0644') }

      describe 'package_ensure option' do
        context 'when set to present' do
          let(:params) do
            {
              package_ensure: 'present',
            }
          end

          it { is_expected.to contain_package('snapserver').with(ensure: 'present') }
        end
        context 'defaults to present' do
          it { is_expected.to contain_package('snapserver').with(ensure: 'present') }
        end
        context 'when set to absent' do
          let(:params) do
            {
              package_ensure: 'absent',
            }
          end

          it { is_expected.to contain_package('snapserver').with(ensure: 'absent') }
        end
      end
      describe 'start option' do
        context 'when set to true' do
          let(:params) do
            {
              start: 'true',
            }
          end

          it { is_expected.to contain_file('/etc/default/snapserver').with('content' => %r{^START_SNAPSERVER=true\n}) }
        end
        context 'defaults to true' do
          it { is_expected.to contain_file('/etc/default/snapserver').with('content' => %r{^START_SNAPSERVER=true\n}) }
        end
        context 'when set to false' do
          let(:params) do
            {
              start: 'false',
            }
          end

          it { is_expected.to contain_file('/etc/default/snapserver').with('content' => %r{^START_SNAPSERVER=false\n}) }
        end
      end
      describe 'user_opts option' do
        context 'defaults to empty' do
          it { is_expected.to contain_file('/etc/default/snapserver').with('content' => %r{^USER_OPTS=""\n}) }
        end
        context 'when set' do
          let(:params) do
            {
              user_opts: '--user snapserver:snapserver',
            }
          end

          it { is_expected.to contain_file('/etc/default/snapserver').with('content' => %r{^USER_OPTS="--user snapserver:snapserver"\n}) }
        end
      end
      describe 'opts option' do
        context 'defaults to empty' do
          it { is_expected.to contain_file('/etc/default/snapserver').with('content' => %r{^SNAPSERVER_OPTS=""\n}) }
        end
        context 'when set' do
          let(:params) do
            {
              opts: '-d -s pipe:///tmp/snapfifo?buffer_ms=20&codec=flac&name=default&sampleformat=48000:16:2',
            }
          end

          # escaping / and ? for match
          it { is_expected.to contain_file('/etc/default/snapserver').with('content' => %r{SNAPSERVER_OPTS="-d -s pipe:\/\/\/tmp\/snapfifo\?buffer_ms=20&codec=flac&name=default&sampleformat=48000:16:2"$}) }
        end
      end
    end
  end
end
