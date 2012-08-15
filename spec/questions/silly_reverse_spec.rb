require 'spec_helper'

class String
  include SillyReverse
end

describe SillyReverse do

  it 'should reverse the string in place' do
    a = 'Hello, World!'
    SillyReverse.silly_reverse!(a)
    a.should == '!dlroW ,olleH'
  end

  it 'should perform reverse on string' do
    a = 'Hello, World!'
    a.silly_reverse!
    a.should == '!dlroW ,olleH'
  end

  it 'should perform reverse on string' do
    a = 'Hello, Worlds!'
    a.silly_reverse!
    a.should == '!sdlroW ,olleH'
  end

end
