require 'ostruct'
require 'forwardable'
require 'exogenesis/support/spacesuit'

class Ship
  extend Forwardable

  def initialize(raw_config)
    config = OpenStruct.new(raw_config)
    @package_managers = []
    config.passengers.each do |passenger_name|
      passenger = Passenger.by_name(passenger_name).new(config)
      @package_managers << Spacesuit.new(passenger)
    end
  end

  def_delegator :@package_managers, :each

  def setup
    each(&:setup)
  end

  def install
    each(&:install)
  end

  def cleanup
    each(&:cleanup)
  end

  def update
    each(&:update)
  end

  def teardown
    each(&:teardown)
  end
end
