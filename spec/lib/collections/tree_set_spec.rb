require 'spec_helper'
require 'lib/collections/tree_set'


describe TreeSet do
  let(:comparator) { nil }
  subject { TreeSet.new(&comparator) }

  describe :initialize do

    context 'without comparator' do
      subject { TreeSet.new }
      its(:comparator) { should_not == nil }
    end

    context 'with custom comparator' do
      let(:comparator) { Proc.new { |a,b| a <=> b } }
      subject { TreeSet.new(&comparator) }
      its(:comparator) { should == comparator }
    end

  end

  describe :methods do
    
    describe :add do
      let(:items) { [] }
      let(:items_expected) { [] }
      before do
        items.each { |item|
          subject << item
        }
      end

      context 'with natural comparator' do
        let(:items_expected) { items.uniq!; items.sort! }

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

      end # natural comparator

      context 'with custom comparator' do
        let(:comparator) { Proc.new { |a,b| a.size <=> b.size } }

        context 'with nonunique items not in order' do
          let(:items) { ['this', 'this', 'was', 'a', 'funny', 'pepper'] }
          let(:items_expected) { ['a', 'was', 'this', 'funny', 'pepper'] }
          it { should == items_expected }
        end

      end

    end # add

  end # methods

end
