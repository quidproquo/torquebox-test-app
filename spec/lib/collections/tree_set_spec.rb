require 'spec_helper'
require 'lib/collections/tree_set'


describe TreeSet do
  subject { TreeSet.new }

  describe :initialize do

    context 'with an array' do
      # let(:array) { [4, 3, 3, 1] }
      # subject { TreeSet.new(array) }
      # it { should == array.sort }
    end
  end

  describe :methods do

    describe :insert do
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

        context 'when concatenating arrays' do
          let(:items) { [1, 3, 5, 2, 4] }
          let(:new_items) { [1, 7, 6, 9, 8] }
          let(:items_expected) { [1, 2, 3, 4, 5, 6, 7, 8, 9] }
          before do
            subject.concat(new_items)
          end
          it { should == items_expected }
        end

      end # natural comparator

    end # add

    describe :get_head_set do
      let(:items) { [1, 2, 3, 4, 5, 8, 9] }
      let(:item) { nil }
      let(:inclusive) { nil }
      let(:head_set) { subject.get_head_set(item, inclusive) }
      before do
        subject.concat(items)
      end

      context 'when inclusive is true' do
        let(:inclusive) { true }

        context 'when item is less than first item' do
          let(:item) { 0 }
          it { head_set.should == [] }
        end

        context 'when item is same as first item' do
          let(:item) { 1 }
          it { head_set.should == [1] }
        end

        context 'when item is middle item' do
          let(:item) { 3 }
          it { head_set.should == [1, 2, 3] }
        end

        context 'when item is not in list item' do
          let(:item) { 7 }
          it { head_set.should == [1, 2, 3, 4, 5] }
        end

        context 'when item is last item' do
          let(:item) { 9 }
          it { head_set.should == items }
        end

        context 'when item is greater than last item' do
          let(:item) { 10 }
          it { head_set.should == items }
        end

      end # inclusive is true

      context 'when inclusive is false' do
        let(:inclusive) { false }

        context 'when item is less than first item' do
          let(:item) { 0 }
          it { head_set.should == [] }
        end

        context 'when item is same as first item' do
          let(:item) { 1 }
          it { head_set.should == [] }
        end

        context 'when item is the second item' do
          let(:item) { 2 }
          it { head_set.should == [1] }
        end

        context 'when item is middle item' do
          let(:item) { 3 }
          it { head_set.should == [1, 2] }
        end

        context 'when item is not in list item' do
          let(:item) { 7 }
          it { head_set.should == [1, 2, 3, 4, 5] }
        end

        context 'when item is last item' do
          let(:item) { 9 }
          it { head_set.should == items[0..-2] }
        end

        context 'when item is greater than last item' do
          let(:item) { 10 }
          it { head_set.should == items }
        end

      end # inclusive is true

    end # get head set

  end # methods

  describe :caching do
    it 'should be cacheable' do
      Rails.cache.write('key', subject)
    end
  end

end
