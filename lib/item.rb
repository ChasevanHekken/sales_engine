class Item
  attr_reader :id,
              :name,
              :description,
              :unit_price,
              :merchant_id,
              :created_at,
              :updated_at,
              :repo

  def initialize(data, repo)
    @id =          data[:id]
    @name =        data[:name]
    @description = data[:description]
    @unit_price =  data[:unit_price]
    @merchant_id = data[:merchant_id]
    @created_at =  data[:created_at]
    @updated_at =  data[:updated_at]
    @repo =        repo
  end

  def invoice_items
    @ii ||= repo.invoice_item_for(id)
  end

  def merchant
    @merc ||= repo.merchant_for(merchant_id)
  end

  def best_day
    invoice_items.each_with_object(Hash.new(0)) do |item, hash|
      hash[item.invoice.created_at] += item.quantity if item.invoice.success?
    end.max_by { |date, sales| sales }.first.to_date
  end

  def revenue
    @rev ||= sum_up(:revenue)
  end

  def sold_items
    @si ||= sum_up(:quantity)
  end

  def sum_up(attribute)
    successful_inv_items.reduce(0) { |sum, item| sum + item.send(attribute) }
  end

  def successful_inv_items
    @sii ||= invoice_items.select(&:success?)
  end
end
