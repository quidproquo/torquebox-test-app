require 'spec_helper'

describe Order do

  describe :initialize do

    context :new do
      subject { Order.new }
      it { should be_an_instance_of(Order) }
    end

  end

end
