require 'lsv_plus/formatting_helper'

RSpec.describe LSVplus::FormattingHelper do
  describe '.date' do
    let(:value) { Date.new(2016, 1, 31) }

    subject { described_class.date value }

    it { is_expected.to eq('20160131') }
  end

  describe '.index' do
    let(:value) { 1 }

    subject { described_class.index value }

    it { is_expected.to eq('0000001') }
  end

  describe '.amount' do
    let(:value) { 133 }

    subject { described_class.amount value }

    it { is_expected.to eq('000000133,00') }
  end

  describe '.multiline' do
    let(:value) { ['Somewhere', 'else'] }

    subject { described_class.multiline value }

    it { is_expected.to eq('Somewhere                          else                                                                                                     ') }
  end

  describe '.account' do
    let(:value) { 'asd-1.233' }

    subject { described_class.account value }

    it { is_expected.to eq('asd-1.233                         ') }
  end

  describe '.clearing_number' do
    let(:value) { '233' }

    subject { described_class.clearing_number value }

    it { is_expected.to eq('233  ') }
  end
end
