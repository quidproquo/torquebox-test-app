require 'spec_helper'
require 'lib/collections/tree_set'


describe TreeSet do
  subject { TreeSet.new }

  describe :initialize do

    context 'without comparator' do
      subject { TreeSet.new }
      its(:comparator) { should_not == nil }
    end

    context 'with comparator' do
      let(:comparator) { Proc.new { |a,b| a <=> b } }
      subject { TreeSet.new(&comparator) }
      its(:comparator) { should == comparator }
    end

  end

  describe :methods do
    
    describe :add do
      let(:items) { [] }
      let(:items_expected) { items.uniq!; items.sort! }
      before do
        items.each { |item|
          subject << item
        }
      end

      context 'when items are all unique in order' do
        let(:items) { [1, 2, 3, 4, 5] }
        it { should == items_expected }
      end

      context 'when items are all unique and not in order' do
        let(:items) { [1, 3, 5, 2, 4] }
        it { should == items_expected }
      end

      context 'when items are not unique and in order' do
        let(:items) { [1, 1, 1, 2, 2, 3, 4, 5, 5, 5, 5] }
        it { should == items_expected }
      end

      context 'when items are not unique and not in order' do
        let(:items) { [1, 1, 1, 3, 3, 5, 2, 2, 2, 2, 4, 4] }
        it { should == items_expected }
      end

    end # add

  end # methods

end
