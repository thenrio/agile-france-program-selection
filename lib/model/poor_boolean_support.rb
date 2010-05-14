module PoorBooleanSupport
  def quack_on_question_mark(*symbols)
    for symbol in symbols do
      module_eval <<-RUBY
        def #{symbol}?
          not #{symbol} == 0  
        end
      RUBY
    end
  end
end