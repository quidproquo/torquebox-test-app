require 'spec_helper'

describe Position do

  subject { Position.new }

  describe :factory do

    describe :position do
      subject { build(:position) }
      it { should be_valid }
    end

    describe :rich_position do
      subject { build(:rich_position) }
      it { should be_valid }
      its(:quantity) { should > 0 }
    end

  end

  describe :initialize do
    it { should be_instance_of(Position) }
    its(:quantity) { should == 0 }
  end

  describe :associations do
    it { should belong_to(:account) }
    it { should belong_to(:product) }
  end

  describe :validation do

    describe :account do
      it { should validate_presence_of(:account) }
      it { should validate_presence_of(:product) }
    end

  end # validation

  describe :methods do
    subject { build(:position) }

    describe :credit do
      let(:initial_quantity) { nil }
      let(:credit_amount) { nil }
      let(:get_result) { subject.credit(credit_amount) }
      subject { build(:position, quantity: initial_quantity) }

      context 'when there is no initial quantity' do
        let(:initial_quantity) { 0 }

        context 'when credit qty is greater than 0' do
          let(:credit_amount) { 100 }
          before { get_result }
          its(:quantity) { should == initial_quantity + credit_amount }
        end

        context 'when credit qty is equal to 0' do
          let(:credit_amount) { 0 }
          before { get_result }
          its(:quantity) { should == initial_quantity + credit_amount }
        end

        context 'when credit qty is less than 0' do
          let(:credit_amount) { -100 }
          it 'should raise an error' do
            lambda{ get_result }.should raise_error(ArgumentError)
            subject.quantity.should == initial_quantity
          end
        end

      end

    end

  end

end
