module ChefZookeeperd
  class << self
    def config_format(key, value)
      k = format_key(key)
      res = "#{k}="
      case value
      when Array
        count = 0
        res = value.map{ |v|
          count += 1
          config_format("#{k}.#{count}", v)
        }.join("\n")
      else
        res << value.to_s
      end
      res
    end

    def format_key(k)
      parts = k.split('_')
      count = 0
      parts.map{|part|
        count += 1
        count > 1 ? part.capitalize : part
      }.join
    end
  end
end
