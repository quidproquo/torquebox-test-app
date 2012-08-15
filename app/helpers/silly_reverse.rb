module SillyReverse

  def self.silly_reverse!(string)
    string.chars.each_with_index { |c,i|
      if i < string.length/2
        string[i], string[-(i+1)] = string[-(i+1)], string[i]
      else
        break
      end
    }
  end

  def silly_reverse!
    SillyReverse.silly_reverse!(self)
  end

end


