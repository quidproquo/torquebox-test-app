require 'spec_helper'

describe Account do

  describe :initialize do

    context :new do
      subject { Account.new }
      it { should be_an_instance_of(Account) }
    end

  end

end
