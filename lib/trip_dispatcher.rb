require 'csv'
require 'time'
require 'awesome_print'
require 'pry'

require_relative 'user'
require_relative 'trip'

module RideShare
  class TripDispatcher
    attr_reader :drivers, :passengers, :trips

    def initialize(user_file = 'support/users.csv',
                   trip_file = 'support/trips.csv', driver_file = 'support/drivers.csv')
      @passengers = load_users(user_file)
      @trips = load_trips(trip_file)
      @drivers =  load_drivers(driver_file)
    end


    def load_users(filename)
      users = []

      CSV.read(filename, headers: true).each do |line|
        input_data = {}
        input_data[:id] = line[0].to_i
        input_data[:name] = line[1]
        input_data[:phone] = line[2]
        users << User.new(input_data)
      end
      return users
    end


    def load_drivers(filename) # use add_driven_trips method here
      # load drivers, collect the instances
      # if driver id is user id
      # in the passenger array, replace the old information with the new combined info
      # users = load_users('./support/users.csv')
      drivers = []

      CSV.read(filename, headers: true).each do |line|
        input_data = {}

        # input_data[:phone] = user.phone_number

        input_data[:id] = line[0].to_i
        input_data[:vin] = line[1]
        input_data[:status] = line[2].to_sym
        # input_data[:driver_trips] = []

        #info from user data above via find_passenger method
        user = find_passenger(line[0].to_i)
        input_data[:name] = user.name

        drivers << Driver.new(input_data)
      end

    return drivers
    end


    # Modify TripDispatcher#load_trips to store the start_time and end_time as Time instances
    def load_trips(filename) #WAVE 2 updating driver passengers
      trips = []
      trip_data = CSV.open(filename, 'r', headers: true,
                                          header_converters: :symbol)
      trip_data.each do |raw_trip|
        passenger = find_passenger(raw_trip[:passenger_id].to_i)
        driver = find_driver(raw_trip[:driver_id].to_i)
        parsed_trip = {
          id: raw_trip[:id].to_i,
          passenger: passenger,
          driver: driver,
          start_time: Time.parse(raw_trip[:start_time]), # rawtrip hash start_time in new_hash parsed_trip
          end_time: Time.parse(raw_trip[:end_time]),
          cost: raw_trip[:cost].to_f,
          rating: raw_trip[:rating].to_i

        }

        trip = Trip.new(parsed_trip)
        passenger.add_trip(trip)
        trips << trip
      end

      return trips
    end


    def find_passenger(id)
      check_id(id)
      return @passengers.find { |passenger| passenger.id == id }
    end

    def find_driver(id) #finds the id that is in the drivers array
      check_id(id)
      return @drivers.find { |driver| driver.id == id }
    end

    def inspect
      return "#<#{self.class.name}:0x#{self.object_id.to_s(16)} \
              #{trips.count} trips, \
              #{drivers.count} drivers, \
              #{passengers.count} passengers>"
    end

    private

    def check_id(id)
      raise ArgumentError, "ID cannot be blank or less than zero. (got #{id})" if id.nil? || id <= 0
    end
  end
end
