module Analyzable
  def average_price(objs)
    (objs.map{|obj| obj.price.to_f}.inject(:+) / objs.length).round(2)
  end

  def print_report(objs)
    report = "Inventory by Brand:\n"
    brands = count_by_brand(objs)
    brands.each{|k,v| report += "  - #{k}: #{v}\n"}
    names = count_by_name(objs)
    names.each{|k,v| report += "  - #{k}: #{v}\n"}
    report
  end

  def count_by_brand(objs)
    brands = {}
    objs.each {|obj| brands[obj.brand] = (brands[obj.brand] || 0) + 1}
    brands
  end

  def count_by_name(objs)
    names = {}
    objs.each {|obj| names[obj.name] = (names[obj.name] || 0) + 1}
    names
  end
end
