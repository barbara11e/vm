require_relative 'Vm'

class Report 
  def self.get_prices()
    prices = {}
    CSV.read('prices.csv').each { |p| prices[p[0]] = p[1].to_i }
    return prices
  end

  def self.get_vm_prices
    vm_prices = {}
    prices = get_prices
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
    return Hash[vm_prices.sort_by { |k,v| -v }[0...n]]
  end

  def self.cheapest(n)
    # выводит n самых дешевых ВМ
    vm_prices = get_vm_prices
    return Hash[vm_prices.sort_by { |k,v| v }[0...n]]
  end

  def self.highest_volume(n)
    # Выводит n самых объемных ВМ по параметру type
    vm_volumes = {}
    Vm.all.each do |vm|
      vm_volume = vm.hdd_capacity.to_i
      vm_volumes[vm] = vm_volume
      vm_volumes[vm] += vm.additional_volume
    end
    return Hash[vm_volumes.sort_by { |k,v| -v }[0...n]]
  end

  def self.most_added_hdd(n, hdd_type: nil)
    # Выводит n ВМ у которых подключено больше всего дополнительных дисков (по количеству) (с учетом типа диска если параметр hdd_type указан)

  end

  def self.most_added_capacity(n)
    # Отчет который выводит n ВМ у которых подключено больше всего дополнительных дисков (по объему) (с учетом типа диска если параметр hdd_type указан)
    vm_volumes = {}
    Vm.all.each do |vm|
      vm_volumes[vm] = vm.additional_volume
    end
    return Hash[vm_volumes.sort_by { |k,v| -v }[0...n]]
  end

end

pp Report.most_expensive(3)
pp Report.cheapest(3)
pp Report.highest_volume(3)
pp Report.most_added_capacity(3)