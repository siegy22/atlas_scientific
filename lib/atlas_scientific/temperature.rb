require 'atlas_scientific/i2c_device'

module AtlasScientific
  # Abstraction layer to EZO RTD Temperature Circuit
  # https://www.atlas-scientific.com/product_pages/circuits/ezo_rtd.html
  class Temperature < I2CDevice
    def initialize(address = 0x66)
      super(address)
    end
  end
end
