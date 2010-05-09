class Invoiceable
  attr_accessor :code, :quantity, :price
  def initialize(code='AGF10P270', quantity=1, price=nil)
    self.code = code
    self.quantity = quantity
    self.price = price
  end

  def ==(other)
    code == other.code and quantity == other.quantity 
  end

  def price=(price)
    unless price
      code =~ /AGF10(\D+)(\d+)/
      price = Integer($2) if $2
    end
    @price = price
  end
end