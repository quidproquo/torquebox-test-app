class TreeSet < Array

  attr_reader :comparator

  def initialize(&comparator)
    super()
    @comparator = comparator || Proc.new { |x,y| x <=> y }
    sort! &comparator
  end

  def insert(i, v)
    # The next line could be further optimized to perform a
    # binary search.
    unless include?(v)
      insert_before = index(find { |x| comparator.call(x, v) == 1 })
      super(insert_before ? insert_before : -1, v)
    end
  end

  def <<(v)
    insert(0, v)
  end

  alias push <<
  alias unshift <<

end
