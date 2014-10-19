require 'date'

class Customer
  attr_reader :id,
              :first_name,
              :last_name,
              :created_at,
              :updated_at,
              :repo

  def initialize(data, repo)
    @id =          data[:id]
    @first_name =  data[:first_name]
    @last_name =   data[:last_name]
    @created_at =  data[:created_at]
    @updated_at =  data[:updated_at]
    @repo =        repo
  end

  def invoices
    @inv ||= repo.invoices_for(id)
  end

  def transactions
    @trans ||= invoices.flat_map { |invoice| invoice.transactions }
  end

  def favorite_merchant
    grouped_merchants.max_by { |merchant, invoices| invoices.size }.first
  end

  def grouped_merchants
    successful_trans = transactions.select(&:success?)
    successful_trans.group_by { |transaction| transaction.invoice.merchant }
  end

  def items
    @itm ||= successful_inv_items.reduce(0) { |sum, item| sum + item.quantity }
  end

  def successful_inv_items
    @sii ||= successful_invoices.flat_map(&:invoice_items)
  end

  def revenue
    @rev ||= successful_invoices.reduce(0) do |sum, invoice|
      sum + invoice.revenue
    end
  end

  def successful_invoices # needs to change on fly
    invoices.select(&:success?)
  end

  def pending_invoices # needs to change on fly
    invoices - successful_invoices
  end

  def days_since_activity
    dates = successful_invoices.map(&:created_at)
    (Date.today - dates.max.to_date).to_i
  end
end
