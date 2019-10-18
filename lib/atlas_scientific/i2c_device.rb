module AtlasScientific
  class I2CDevice
    class NoDataToSendError < StandardError; end
    class StillProcessingError < StandardError; end
    class CommandSyntaxError < StandardError; end
    class UnknownStatusCodeError < StandardError; end

    STILL_PROCESSING = 254
    I2C_SLAVE = 0x0703


    def initialize(address, path: Dir.glob('/dev/i2c-*').first)
      @address = address
      @path = path
    end

    # Takes a reading using the "r" ezo command
    # and casts it to a float
    def reading
      r.to_f
    end
    alias take_reading reading
    alias read reading

    # Takes a reading with a given temperature
    # and casts it to a float
    def take_reading_with_temperature_compensation(temperature)
      rt(temperature.to_s).to_f
    end

    def calibrated?
      !execute('cal', '?').casecmp?('?cal,0')
    end

    [
      'baud',
      'cal',
      'factory',
      'find',
      'i',
      'i2c',
      'l',
      'o',
      'plock',
      'r',
      'rt',
      'sleep',
      'status',
      't'
    ].each do |cmd|
      define_method(cmd) do |*args|
        execute(cmd, *args)
      end
    end

    alias information i

    alias temperature_compensation t

    alias protocol_lock plock

    def execute(command, *args)
      io = File.open(@path, 'r+')
      # Set i2c address and mode
      io.ioctl(I2C_SLAVE, @address)

      # Prepare EZO command like
      ezo_command = [command, *args].join(',')

      io.syswrite(ezo_command)
      return if command == 'sleep'

      # Wait for the command to finish
      result, status = loop do
        result = io.read(31)
        status = result[0].unpack1('C')
        break [result, status] unless status == STILL_PROCESSING
      end

      check_for_status_code(status, ezo_command)
      result[1..-1].strip
    ensure
      io&.close
    end

    def check_for_status_code(code, ezo_command)
      return if code == 1

      case code
      when 255
        raise NoDataToSendError
      when 2
        raise CommandSyntaxError, "There was an error executing the following command: #{ezo_command}\n" \
                                  'Please check the documentation of your circuit.'
      else
        raise UnknownStatusCodeError, "Unkown Response code: #{code} received from device.\n" \
                                      'Check the latest datasheet of atlas scientific.'
      end
    end
  end
end
