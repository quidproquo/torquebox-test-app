class TreeSet < Array

  # Overrides:

  def concat(other_array)
    other_array.each { |item|
      self << item
    }
    self
  end

  def insert(i, v)
    # The next line could be further optimized to perform a
    # binary search.
    unless include?(v)
      insert_before = index { |x| (x <=> v) == 1 }
      super(insert_before ? insert_before : -1, v)
    end
  end

  def <<(v)
    insert(0, v)
  end

  alias push <<
  alias unshift <<

  # Methods:

  def get_head_set(v, inclusive = true)
    last_index = nil
    if inclusive
      last_index = rindex { |x| (x <=> v) <= 0 } || -1
    else
      last_index = index { |x| (x <=> v) >= 0 } || length
      last_index -= 1
    end
    self[0, last_index + 1]
  end

end
