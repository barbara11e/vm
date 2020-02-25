require 'csv'

class Volume
  attr_accessor :vm_id, :hdd_type, :hdd_capacity

  def self.all()
    volumes = []
    CSV.read(name).each { |volume| volumes.push new(volume)}
    return volumes
  end

  def inspect
    "Additional volume for ##{vm_id}: #{hdd_type}"
  end

  def self.where(vm_id: "98", name: "volumes.csv")
    volumes = []
    CSV.read(name).each { |volume| volumes.push new(volume) if volume[0] == vm_id}
    return volumes
  end

  private_class_method :new
  def initialize(args)
    self.vm_id = args[0]
    self.hdd_type = args[1]
    self.hdd_capacity = args[2]
  end
end
