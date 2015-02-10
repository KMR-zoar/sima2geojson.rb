#!/usr/bin/env ruby
# encofing: utf-8

require 'json'
require 'kconv'

filename = ARGV[0]
name = ARGV[1].to_s
number = ARGV[2].to_s
featuresstock = []

epsg2000 = {"1"=>"2443", "2"=>"2444", "3"=>"2445", "4"=>"2446", "5"=>"2447", "6"=>"2448", "7"=>"2449", "8"=>"2450", "9"=>"2451", "10"=>"2452", "11"=>"2453", "12"=>"2454", "13"=>"2455", "14"=>"2456", "15"=>"2457", "16"=>"2458", "17"=>"2459", "18"=>"2460", "19"=>"2461"}

epsg2011 = {"1"=>"6669", "2"=>"6670", "3"=>"6671", "4"=>"6672", "5"=>"6673", "6"=>"6674", "7"=>"6675", "8"=>"6676", "9"=>"6677", "10"=>"6678", "11"=>"6679", "12"=>"6680", "13"=>"6681", "14"=>"6682", "15"=>"6683", "16"=>"6684", "17"=>"6685", "18"=>"6686", "19"=>"6687"}

case name
when "2000"
   epsgcode = epsg2000[number]
when "2011"
   epsgcode = epsg2011[number]
else
   puts "unknown name"
end

# Create CRS Properties
crsproperties = {"name" => "urn:ogc:def:crs:EPSG::#{epsgcode}"}
crs = {"type" => "name", "properties" => crsproperties}

open(filename) do |sima|
   sima.each do |simaline|
      simaline = simaline.kconv(Kconv::UTF8)
      if simaline =~ /^A01/
         simaline = simaline.split(",")
         simaline.each do |column|
            column.strip!
         end
         coordinates = [simaline[4].to_f, simaline[3].to_f]
         geometry = {"type" => "Point", "coordinates" => coordinates}
         properties = {"Number" => simaline[1], "Name" => simaline[2]}
         features = {"type" => "Feature", "properties" => properties, "geometry" => geometry}
         featuresstock << features
      end
   end
end

puts JSON.generate("type"=> "FeatureCollection", "crs" => crs ,"features" => featuresstock)

