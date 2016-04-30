require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata
  extend Finder

  @@attributes = ["id", "brand", "name", "price"]
  @@file = File.dirname(__FILE__) + "/../data/data.csv"

  self.create_finder_methods(*@@attributes)

  def self.create(opts={})
    product = self.new(opts)
    self.add_row([product.id, product.brand, product.name, product.price])
    product
  end

  def self.all
    self.all_rows.map{|row| row_to_object(row)}
  end

  def self.first(n=1)
    objects = self.all_rows.first(n).map{|row| row_to_object(row)}
    if n > 1
      return objects
    else
      return objects[0]
    end
  end

  def self.last(n=1)
    objects = self.all_rows.last(n).map{|row| row_to_object(row)}
    if n > 1
      return objects
    else
      return objects[0]
    end
  end

  def self.find(id)
    if !self.find_by_id(id)
      raise ProductNotFoundError
    end
    self.find_by_id(id)
  end

  def self.destroy(id)
    row = self.find(id)
    self.delete_row(row.id)
    row
  end

  def self.where(opts={})
    self.all.select{|obj| opts.map{|k,v| obj.send(k) == v}.all?}
  end

  def update(opts={})
    obj = self.class.destroy(self.id)
    @@attributes.each{|k| opts[k.to_sym] = opts[k.to_sym] || obj.send(k)}
    self.class.create(opts)
  end

  private

  def self.add_row(row)
    CSV.open(@@file, "ab") do |csv|
      csv << row
    end
  end

  def self.all_rows
    csv = CSV.read(@@file)
    csv.shift
    csv
  end

  def self.delete_row(id)
    rows = self.all_rows.reject{|row| row[0] == id.to_s}
    CSV.open(@@file, 'wb', :headers => true) do |csv|
      csv << ["id", "brand", "product", "price"]
      rows.each {|row| csv << row}
    end
  end

  def self.row_to_object(row)
    self.new(id: row[0], brand: row[1], name: row[2], price: row[3])
  end
end
