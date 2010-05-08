class Invoiceable
  attr_accessor :code, :quantity
  def initialize(code='AGF10P270', quantity=1)
    self.code = code
    self.quantity = quantity
  end

  def ==(other)
    code == other.code and quantity == other.quantity 
  end

  def price
    220
  end
end