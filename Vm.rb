require 'csv'
require_relative 'Volume'

class Vm
  attr_accessor :id, :cpu, :ram, :hdd_type, :hdd_capacity

  def self.all(name: "vms.csv")
    vms = []
    CSV.read(name).each { |vm| vms.push new(vm) }
    return vms
  end

  def inspect
    "VM##{id} - hdd:#{hdd_type}; "
  end

  def additional_volumes
    Volume.where vm_id: self.id
  end

  def additional_volume
    Volume.where(vm_id: self.id).inject(0){|sum,x| sum + x.hdd_capacity.to_i }
  end

  private_class_method :new
  def initialize(args)
    self.id = args[0]
    self.cpu = args[1]
    self.ram = args[2]
    self.hdd_type = args[3]
    self.hdd_capacity = args[4]
  end 
end
