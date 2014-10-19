require_relative 'transaction'
require_relative 'repository_methods'

class TransactionRepository
  include RepositoryMethods

  attr_reader :instances, :engine

  def attributes
    [
      'id',
      'invoice_id',
      'credit_card_number',
      'credit_card_expiration_date',
      'result',
      'created_at',
      'updated_at'
    ]
  end

  def initialize(data, engine)
    @instances =  data.map { |row| Transaction.new(row, self) }
    @engine = engine
    define_finder_methods
  end

  def invoice_for(invoice_id)
    engine.invoice_for_transaction(invoice_id)
  end
end
