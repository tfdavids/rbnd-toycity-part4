module Finder
  def create_finder_methods(*attributes)
    attributes.each do |attribute|
      self.class_eval("def self.find_by_#{attribute}(value); self.all.keep_if{|row| row.#{attribute} == value}[0]; end")
    end
  end
end
