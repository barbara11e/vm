require 'csv'

class Volume
  attr_accessor :vm_id, :hdd_type, :hdd_capacity

  def inspect
    "Additional volume for ##{vm_id}: #{hdd_type}"
  end

  def self.where(vm_id, hdd_type, name: "data/volumes.csv")
    volumes = []
    CSV.read(name).each { |volume| volumes.push new(*volume) if volume[0] == vm_id}
    volumes = volumes.select { |el| el.hdd_type == hdd_type } if hdd_type
    return volumes
  end

  def initialize(vm_id, hdd_type, hdd_capacity)
    self.vm_id = vm_id
    self.hdd_type = hdd_type
    self.hdd_capacity = hdd_capacity
  end
end

Volume.where(3, "sas")