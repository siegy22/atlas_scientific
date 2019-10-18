require 'atlas_scientific/i2c_device'

module AtlasScientific
  # Abstraction layer to EZO pH Circuit
  # https://www.atlas-scientific.com/product_pages/circuits/ezo_ph.html
  class PH < I2CDevice
    def initialize(address = 0x63)
      super(address)
    end

    def slope
      execute('slope', '?')
    end
  end
end
