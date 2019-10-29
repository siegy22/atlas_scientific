require 'test_helper'

class I2CDeviceTest < ActiveSupport::TestCase
  setup do
    @device = AtlasScientific::I2CDevice.new(0x00)
  end

  test 'does correctly handle io (ioctl, syswrite, read etc.)' do
    mock = Minitest::Mock.new
    mock.expect :ioctl, true, [0x0703, 0x01]
    mock.expect :syswrite, true, ['r']
    mock.expect :read, "\x012.01\x00", [31]
    mock.expect :close, nil

    File.stub(:open, mock) do
      device = AtlasScientific::I2CDevice.new(0x01)
      assert_equal '2.01', device.r
    end

    assert_mock mock
  end

  test 'take a reading' do
    with_i2c_response(1, '20.01') do
      assert_equal '20.01', @device.r
      assert_equal 20.01, @device.take_reading
      assert_equal 20.01, @device.reading
    end
  end

  test 'check for device calibration' do
    with_i2c_response(1, '?CAL,2') do
      assert @device.calibrated?
    end

    with_i2c_response(1, '?CAL,0') do
      assert_not @device.calibrated?
    end
  end

  private
  def with_i2c_response(status, response)
    return_value = "#{[status.to_s].pack('h')}#{response}\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
    File.stub(:open, MockIO.new(return_value)) do |*|
      yield
    end
  end

  class MockIO
    def initialize(val)
      @read_value = val
    end

    def close(*); end

    def ioctl(*); end

    def syswrite(*); end

    def read(*)
      @read_value
    end
  end
end
