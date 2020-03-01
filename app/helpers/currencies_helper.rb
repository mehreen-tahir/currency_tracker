module CurrenciesHelper
  def big_decimal_converter(value)
    ("%.8f" % value)
  end
end
