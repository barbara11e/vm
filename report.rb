require_relative 'Vm'

class Report 
  def self.prices()
    @prices ||= CSV.read('data/prices.csv', converters: %i[numeric]).to_h
  end

  def self.get_vm_prices
    vm_prices = {}
    Vm.all.each do |vm|
      vm_price = vm.cpu.to_i * prices["cpu"]
      vm_price += vm.ram.to_i * prices["ram"]
      vm_price += vm.hdd_capacity.to_i * prices[vm.hdd_type]
      vm.additional_volumes.each do |add_hdd|
        vm_price += add_hdd.hdd_capacity.to_i * prices[add_hdd.hdd_type]
      end
      vm_prices[vm] = vm_price
    end
    return vm_prices
  end

  def self.most_expensive(n)
    # выводит n самых дорогих ВМ
    vm_prices = get_vm_prices
    return vm_prices.sort_by { |k,v| -v }[0...n].to_h
  end

  def self.cheapest(n)
    # выводит n самых дешевых ВМ
    vm_prices = get_vm_prices
    return vm_prices.sort_by { |k,v| v }[0...n].to_h
  end

  def self.highest_volume(n)
    # Выводит n самых объемных ВМ по параметру type
    vm_volumes = {}
    Vm.all.each do |vm|
      vm_volume = vm.hdd_capacity.to_i
      vm_volumes[vm] = vm_volume
      vm_volumes[vm] += vm.additional_volume
    end
    return vm_volumes.sort_by { |k,v| -v }[0...n].to_h
  end

  def self.most_added_hdd(n, hdd_type: nil)
    # Выводит n ВМ у которых подключено больше всего 
    # дополнительных дисков (по количеству)
    vm_volumes = {}
    Vm.all.each do |vm|
      vm_volumes[vm] = vm.additional_typed_volumes(hdd_type: hdd_type).count
    end
    return vm_volumes.sort_by { |k,v| -v }[0...n].to_h
  end

  def self.most_added_capacity(n, hdd_type: nil)
    # Отчет который выводит n ВМ у которых подключено 
    # больше всего дополнительных дисков (по объему)
    vm_volumes = {}
    Vm.all.each do |vm|
      vm_volumes[vm] = vm.additional_volume(hdd_type: hdd_type)
    end
    return vm_volumes.sort_by { |k,v| -v }[0...n].to_h
  end
end

n = Integer(ENV.fetch('VM_NUMBER', 5))

pp "Отчет о  #{n} самых дорогих ВМ"
pp Report.most_expensive(n)

pp "Отчет о #{n} самых дешевых ВМ"
pp Report.cheapest(n)

pp "Отчет о #{n} самых объемных ВМ по параметру type"
pp Report.highest_volume(n)

pp "Отчет о #{n} ВМ у которых подключено больше всего дополнительных дисков (по количеству)"
pp Report.most_added_hdd(n)

pp "Отчет который выводит #{n} ВМ у которых подключено больше всего дополнительных дисков (по объему)"
pp Report.most_added_capacity(n)