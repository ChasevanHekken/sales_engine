class Merchant
  attr_reader :id,
              :name,
              :created_at,
              :updated_at,
              :repo

  def initialize(data, repo)
    @id =         data[:id]
    @name =       data[:name]
    @created_at = data[:created_at]
    @updated_at = data[:updated_at]
    @repo =       repo
  end

  def items
    @itm ||= repo.items_for(id)
  end

  def invoices
    @inv ||= repo.invoices_for(id)
  end

  def revenue(date=nil)
    return revenue_no_date if date.nil?
    invoices_by(date).reduce(0) { |sum, invoice| sum + invoice.revenue }
  end

  def revenue_no_date
    @rnd ||= successful_invoices.reduce(0) do |sum, invoice|
      sum + invoice.revenue
    end
  end

  def invoices_by(date)
    if (date).respond_to?(:to_a)
      successful_invoices.select do |invoice|
        (date).to_a.include?(invoice.created_at.to_date)
      end
    else
      successful_invoices.select do |invoice|
        date == invoice.created_at.to_date
      end
    end
  end

  def sold_items
    @sold ||= successful_inv_items.reduce(0) { |sum, item| sum + item.quantity }
  end

  def successful_inv_items
    @sii ||= successful_invoices.flat_map(&:invoice_items)
  end

  def favorite_customer
    customers = successful_invoices.map(&:customer)
    customers.uniq.max_by { |customer| customers.count(customer) }
  end

  def customers_with_pending_invoices
    failed_invoices.map(&:customer).uniq
  end

  def successful_invoices
    @si ||= invoices.select(&:success?)
  end

  def failed_invoices
    @fi ||= invoices - successful_invoices
  end
end
