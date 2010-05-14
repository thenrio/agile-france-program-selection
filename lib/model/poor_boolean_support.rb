module PoorBooleanSupport
  def support_bloody_boolean(*symbols)
    for symbol in symbols do
      module_eval <<-RUBY
        def #{symbol}?
          not #{symbol} == 0  
        end
      RUBY
    end
  end
end