class InvoiceItem
  attr_reader :id,
              :item_id,
              :invoice_id,
              :quantity,
              :unit_price,
              :created_at,
              :updated_at,
              :repo

  def initialize(data, repo)
    @id =          data[:id]
    @item_id =     data[:item_id]
    @invoice_id =  data[:invoice_id]
    @quantity =    data[:quantity]
    @unit_price =  data[:unit_price]
    @created_at =  data[:created_at]
    @updated_at =  data[:updated_at]
    @repo =        repo
  end

  def invoice
    @inv ||= repo.invoice_for(invoice_id)
  end

  def item
    @itm ||= repo.item_for(item_id)
  end

  def success?
    @suc ||= invoice.success?
  end

  def revenue
    @rev ||= quantity * unit_price
  end
end
