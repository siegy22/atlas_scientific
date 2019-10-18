require 'atlas_scientific/i2c_device'

module AtlasScientific
  # Abstraction layer to EZO Conductivity Circuit
  # https://www.atlas-scientific.com/product_pages/circuits/ezo_ec.html
  class EC < I2CDevice
    def initialize(address = 0x64)
      super(address)
    end

    def probe_type=(type)
      k(type)
    end

    def k(*args)
      execute('k', *args)
    end
  end
end
