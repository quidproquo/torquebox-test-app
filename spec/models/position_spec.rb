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
      its(:quantity) { should >= 1000000 }
    end

    describe :rich_cash_position do
      subject { build(:rich_cash_position) }
      it { should be_valid }
      its(:quantity) { should >= 1000000 }
      its('product.name') { should == 'CASH' }
    end

  end

  describe :initialize do
    it { should be_instance_of(Position) }
    its(:quantity) { should == 0 }
  end

  describe :fields do
    it { should respond_to(:locked_quantity) }
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
          its(:quantity) { should == initial_quantity }
        end

        context 'when credit qty is less than 0' do
          let(:credit_amount) { -100 }
          it 'should raise an error' do
            lambda{ get_result }.should raise_error(ArgumentError)
            subject.quantity.should == initial_quantity
          end
        end

      end # no init qty

      context 'when there is an initial quantity' do
        let(:initial_quantity) { 1000 }
        let(:credit_amount) { 100 }
        before { get_result }
        its(:quantity) { should == initial_quantity + credit_amount }
      end

    end # credit

    describe :debit do
      let(:initial_quantity) { nil }
      let(:debit_amount) { nil }
      let(:get_result) { subject.debit(debit_amount) }
      subject { build(:position, quantity: initial_quantity) }

      context 'when there an initial quantity' do
        let(:initial_quantity) { 1000 }

        context 'when debit amount is greater than 0' do
          let(:debit_amount) { 100 }
          before { get_result }
          its(:quantity) { should == initial_quantity - debit_amount }
        end

        context 'when debit amount is equal to 0' do
          let(:debit_amount) { 0 }
          before { get_result }
          its(:quantity) { should == initial_quantity }
        end

        context 'when debit amount is less than 0' do
          let(:debit_amount) { -100 }
          it 'should raise an error' do
            lambda{ get_result }.should raise_error(ArgumentError)
            subject.quantity.should == initial_quantity
          end
        end

        context 'when debit amount is less than initial quantity' do
          let(:debit_amount) { initial_quantity + 1 }
          it 'should raise an error' do
            lambda{ get_result }.should raise_error(ArgumentError)
            subject.quantity.should == initial_quantity
          end
        end

      end # an init qty

    end # credit

    describe :lockup do
      let(:initial_quantity) { raise ArgumentError }
      let(:initial_locked_quantity) { raise ArgumentError }
      let(:lockup_amount) { raise ArgumentError }
      let(:get_result) { subject.lockup(lockup_amount) }
      subject { build(:position, quantity: initial_quantity, locked_quantity: initial_locked_quantity) }

      context 'when initial locked quantity is 0' do
        let(:initial_locked_quantity) { 0 }

        context 'when there is no initial quantity' do
          let(:initial_quantity) { 0 }

          context 'when total lockup amount is greater than initial_quantity' do
            let(:lockup_amount) { initial_quantity + 1 }
            it 'should raise an error' do
              lambda{ get_result }.should raise_error(ArgumentError)
              subject.locked_quantity.should == initial_locked_quantity
              subject.quantity.should == initial_quantity
            end
          end

          context 'when lockup amount is less than 0' do
            let(:lockup_amount) { -100 }
            it 'should raise an error' do
              lambda{ get_result }.should raise_error(ArgumentError)
              subject.locked_quantity.should == initial_locked_quantity
              subject.quantity.should == initial_quantity
            end
          end

        end # no init qty

        context 'when there is an initial quantity' do
          let(:initial_quantity) { 1000 }
          let(:lockup_amount) { 100 }
          before { get_result }
          its(:locked_quantity) { should == initial_locked_quantity + lockup_amount }
        end

      end # no init locked qty

      context 'when initial locked quantity is greater than 0' do
        let(:initial_quantity) { 1000 }
        let(:initial_locked_quantity) { 100 }

        context 'when lockup amount plus init locked qty is < initial quantity' do
          let(:lockup_amount) { initial_quantity - initial_locked_quantity - 1 }
          before { get_result }
          its(:locked_quantity) { should == initial_locked_quantity + lockup_amount }
        end

        context 'when lockup amount plus init locked qty is > initial quantity' do
          let(:lockup_amount) { initial_quantity - initial_locked_quantity + 1 }
          it 'should raise an error' do
            lambda{ get_result }.should raise_error(ArgumentError)
            subject.locked_quantity.should == initial_locked_quantity
            subject.quantity.should == initial_quantity
          end
        end

      end # init locked qty

    end # lockup

  end # methods

end
