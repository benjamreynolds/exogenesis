require 'spec_helper'
require 'exogenesis/passengers/rbenv'

describe Rbenv do
  let(:config) { double }
  before { allow(config).to receive(:rubies).and_return(rubies) }

  let(:executor) { executor_double }
  let(:rubies) { ['2.0.0-p353'] }

  subject { Rbenv.new(config, executor) }

  describe :up do

    before do
      allow(executor).to receive(:command_exists?).and_return(true)
    end

    context 'when rbenv does exist' do
      before { allow(executor).to receive(:command_exists?).and_return(false) }

      it 'should install rbenv into ~/.rbenv via git clone.' do
        executor.should_receive(:execute).with('Install rbenv', 'git clone https://github.com/sstephenson/rbenv.git ~/.rbenv')
        executor.should_receive(:execute).with('Install ruby-build plugin', 'git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build')
        subject.up
      end
    end

    it 'should update the rubies provided when initialized' do
      allow(executor).to receive(:execute).with('Getting Installed Verisons', 'rbenv versions').and_yield "  1.9.3-p448\n    2.0.0-p247"
      executor.should_receive(:execute).with('Update rbenv', 'cd ~/.rbenv && git pull')
      executor.should_receive(:execute).with('Update ruby-build', 'cd ~/.rbenv/plugins/ruby-build && git pull')
      executor.should_receive(:execute).with('Installing 2.0.0-p353', 'rbenv install 2.0.0-p353')
      executor.should_receive(:execute).with('Rehash', 'rbenv rehash')
      subject.up
    end

    it 'should install the rubies provided when initialized' do
      executor.should_receive(:execute).with('Installing 2.0.0-p353', 'rbenv install 2.0.0-p353')
      executor.should_receive(:execute).with('Rehash', 'rbenv rehash')
      subject.up
    end
  end

  describe :down do
    it 'should ask to remove the rbenv directory on down' do
      executor.should_receive(:execute_interactive).with('Teardown', 'rm -r ~/.rbenv')
      subject.down
    end
  end

end
