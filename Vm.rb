require 'csv'
require_relative 'Volume'

class Vm
  attr_accessor :id, :cpu, :ram, :hdd_type, :hdd_capacity

  def self.all(name: "data/vms.csv")
    vms = []
    CSV.read(name).each { |vm| vms.push new(*vm) }
    return vms
  end

  def inspect
    "VM##{id}"
  end

  def additional_volumes
    Volume.where self.id
  end

  def additional_volume(hdd_type: nil)
    Volume.where(self.id, hdd_type: hdd_type)
      .inject(0){|sum,x| sum + x.hdd_capacity.to_i }
  end

  def additional_typed_volumes(hdd_type: nil)
    Volume.where(self.id, hdd_type: hdd_type)
  end

  def initialize(id, cpu, ram, hdd_type, hdd_capacity)
    self.id = id
    self.cpu = cpu
    self.ram = ram
    self.hdd_type = hdd_type
    self.hdd_capacity = hdd_capacity
  end 
end
