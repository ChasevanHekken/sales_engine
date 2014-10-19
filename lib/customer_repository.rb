require_relative 'customer'
require_relative 'repository_methods'

class CustomerRepository
  include RepositoryMethods

  attr_reader :instances, :engine

  def attributes
    [
      'id',
      'first_name',
      'last_name',
      'created_at',
      'updated_at'
    ]
  end

  def initialize(data, engine)
    @instances =  data.map { |row| Customer.new(row, self) }
    @engine = engine
    define_finder_methods
  end

  def invoices_for(id)
    engine.invoices_for_customer(id)
  end

  def most_items
    instances.max_by(&:items)
  end

  def most_revenue
    instances.max_by(&:revenue)
  end
end
