require_relative 'spec_helper'


describe "User class" do

  describe "User instantiation" do
    before do
      @user = RideShare::User.new(id: 1, name: "Smithy", phone: "353-533-5334")
    end

    it "is an instance of User" do
      expect(@user).must_be_kind_of RideShare::User
    end

    it "throws an argument error with a bad ID value" do
      expect do
        RideShare::User.new(id: 0, name: "Smithy")
      end.must_raise ArgumentError
    end

    it "sets trips to an empty array if not provided" do
      expect(@user.trips).must_be_kind_of Array
      expect(@user.trips.length).must_equal 0
    end

    it "is set up for specific attributes and data types" do
      [:id, :name, :phone_number, :trips].each do |prop|
        expect(@user).must_respond_to prop
      end

      expect(@user.id).must_be_kind_of Integer
      expect(@user.name).must_be_kind_of String
      expect(@user.phone_number).must_be_kind_of String
      expect(@user.trips).must_be_kind_of Array
    end

  describe "user net_expenditures" do
   it "should calculate net_expenditures" do

     user1 = {:id=>1,:name=>"User1",:phone=>111-111-1111}
     @passenger = RideShare::User.new(user1)
     @trip1 = RideShare::Trip.new({:id=>2,:passenger=>1,:start_time=>"2018-05-25 11:52:40",:end_time=>"2018-05-25 12:25:00",:cost=>10,:rating=>5})
     @trip2 = RideShare::Trip.new({:id=>3,:passenger=>1,:start_time=>"2018-07-23 04:39:00",:end_time =>"2018-07-23 04:55:00",:cost =>7,:rating =>3})

     @passenger.add_trip(@trip1)
     @passenger.add_trip(@trip2)


       total = 0
       @passenger.trips.each do |trip|
         total += trip.cost
       end
expect (total).must_equal 17

    end
  end
end

describe "total time spent" do
it "should calculate total time spent in rides by user" do
  user1 = {:id=>1,:name=>"User1",:phone=>111-111-1111}
  @passenger = RideShare::User.new(user1)
  @trip1 = RideShare::Trip.new({:id=>2,:passenger=>1,:start_time=>"2018-05-25 11:52:40",:end_time=>"2018-05-25 12:25:00",:cost=>10,:rating=>5})
  @trip2 = RideShare::Trip.new({:id=>3,:passenger=>1,:start_time=>"2018-07-23 04:39:00",:end_time =>"2018-07-23 04:55:00",:cost =>7,:rating =>3})

  @passenger.add_trip(@trip1)
  @passenger.add_trip(@trip2)

  duration = ""
  @passenger.trips.each do |trip|
    t1 = Time.parse(trip.start_time)
    t2 = Time.parse(trip.end_time)
    duration += sprintf("%0.02f", (t2 - t1) % 60)
      end
      minutes = (((duration.to_i) / 60) % 60).to_i
  

    expect(minutes).must_equal "48"
end
end




  describe "trips property" do
    before do
      @user = RideShare::User.new(id: 9, name: "Merl Glover III",
                                  phone: "1-602-620-2330 x3723", trips: [])
      trip = RideShare::Trip.new(id: 8, driver: nil, passenger: @user,
                                 start_time: Time.parse("2016-08-08"),
                                 end_time: Time.parse("2016-08-09"),
                                 rating: 5)

      @user.add_trip(trip)
    end

    it "each item in array is a Trip instance" do
      @user.trips.each do |trip|
        expect(trip).must_be_kind_of RideShare::Trip
      end
    end

    it "all Trips must have the same passenger's user id" do
      @user.trips.each do |trip|
        expect(trip.passenger.id).must_equal 9
      end
    end
  end
end
