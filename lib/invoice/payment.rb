class Payment
  attr_accessor :code, :quantity
  def initialize(code='', quantity=1)
  end

  def ==(other)
    code == other.code and quantity == other.quantity 
  end
end