require_relative 'transaction'
require 'time'

class Invoice
  attr_reader :id,
              :customer_id,
              :merchant_id,
              :status,
              :created_at,
              :updated_at,
              :repo

  def initialize(data, repo)
    @id =          data[:id]
    @customer_id = data[:customer_id]
    @merchant_id = data[:merchant_id]
    @status =      data[:status]
    @created_at =  data[:created_at]
    @updated_at =  data[:updated_at]
    @repo = repo
  end

  def transactions # needs to change on fly
    repo.transactions_for(id)
  end

  def invoice_items
    @ii ||= repo.invoice_items_for(id)
  end

  def items
    @itm ||= repo.items_for(id)
  end

  def customer
    @cust ||= repo.customer_for(customer_id)
  end

  def merchant
    @merc ||= repo.merchant_for(merchant_id)
  end

  def success? # needs to change on fly
    transactions.any?(&:success?)
  end

  def revenue
    @rev ||= sum_up(:revenue)
  end

  def sold_items
    @si ||= sum_up(:quantity)
  end

  def sum_up(attribute)
    invoice_items.reduce(0) { |sum, item| sum + item.send(attribute) }
  end

  def charge(args)
    trans_repo = repo.engine.transaction_repository
    data = {
      id:                          trans_repo.instances.last.id.to_i + 1,
      invoice_id:                  id,
      credit_card_number:          args.fetch(:credit_card_number).to_i,
      credit_card_expiration_date: args.fetch(:credit_card_expiration_date),
      result:                      args.fetch(:result),
      created_at:                  Time.now.utc,
      updated_at:                  Time.now.utc
    }
    transaction = Transaction.new(data, trans_repo)
    trans_repo.add_instance(transaction)
    transaction
  end
end
