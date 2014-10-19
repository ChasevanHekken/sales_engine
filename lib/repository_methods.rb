module RepositoryMethods
  def inspect
    "<#{self.class} #{@instances.size} rows>"
  end

  def define_finder_methods
    attributes.each do |attribute|
      find_by(attribute)
      find_all_by(attribute)
    end
  end

  def find_by(attribute)
    define_singleton_method("find_by_#{attribute}") do |input|
      instances.detect do |instance|
        input.to_s.downcase == instance.send(attribute).to_s.downcase
      end
    end
  end

  def find_all_by(attribute)
    define_singleton_method("find_all_by_#{attribute}") do |input|
      instances.select do |instance|
        input.to_s.downcase == instance.send(attribute).to_s.downcase
      end
    end
  end

  def all
    instances
  end

  def random
    instances.sample
  end

  def rank_instances(number, attribute)
    instances.sort_by{ |instance| instance.send attribute }.reverse[0...number]
  end

  def add_instance(instance)
    instances << instance
  end
end
