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
    if code =~ /AGF10(\D+)(\d+)/
      return Integer($2)
    end
  end
end