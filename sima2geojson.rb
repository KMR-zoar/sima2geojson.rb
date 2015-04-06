#!/usr/bin/env ruby
# encofing: utf-8
# This software is released under the MIT License
# see http://opensource.org/licenses/mit-license.php
# Copyright (c) 2015 Zoar

require 'json'
require 'kconv'

filename = ARGV[0]
number = ARGV[1].to_s
pointstock = []
polygonstock = []
points = {}
coordinates = []
properties = {}
mode = 0

unless File.exist?(filename)
   puts "Inaccessible or Not exist."
   exit
end

epsgcodes = {"1"=>"2443", "2"=>"2444", "3"=>"2445", "4"=>"2446", "5"=>"2447", "6"=>"2448", "7"=>"2449", "8"=>"2450", "9"=>"2451", "10"=>"2452", "11"=>"2453", "12"=>"2454", "13"=>"2455", "14"=>"2456", "15"=>"2457", "16"=>"2458", "17"=>"2459", "18"=>"2460", "19"=>"2461"}

epsgcode = epsgcodes[number]

if epsgcode == nil
   puts "Empty or Different code Number, Set a frame of reference code number."
   exit
end

# Create CRS Properties
crsproperties = {"name" => "urn:ogc:def:crs:EPSG::#{epsgcode}"}
crs = {"type" => "name", "properties" => crsproperties}

open(filename) do |sima|
   sima.each do |simaline|
      simaline = simaline.kconv(Kconv::UTF8)
         simaline = simaline.split(",")
         simaline.each do |column|
            column.strip!
         end
         
      if simaline[0] =~ /^A01/
         coordinates = [simaline[4].to_f, simaline[3].to_f]
         geometry = {"type" => "Point", "coordinates" => coordinates}
         properties = {"Number" => simaline[1], "Name" => simaline[2]}
         features = {"type" => "Feature", "properties" => properties, "geometry" => geometry}
         pointstock << features
         points["#{simaline[1]},#{simaline[2]}"] = coordinates
      end

     if simaline[0] =~ /^D00/
        coordinates = []
        properties = {"Number" => simaline[1], "Name" => simaline[2]}
     end

     if simaline[0] =~ /^D99/
        coordinates << coordinates[0]
        coordinates = [coordinates]
        geometry = {"type" => "Polygon", "coordinates" => coordinates}
        features = {"type" => "Feature", "properties" => properties, "geometry" => geometry}
        polygonstock << features
     end

     if simaline[0] =~ /^B01/
        coordinates << points["#{simaline[1]},#{simaline[2]}"]
     end
   end
end

geojson = JSON.generate("type"=> "FeatureCollection", "crs" => crs ,"features" => pointstock)
open(filename.gsub(".sim",".point.geojson"),"w") do |json|
   json.write(geojson)
end

unless polygonstock == []
   geojson = JSON.generate("type"=> "FeatureCollection", "crs" => crs ,"features" => polygonstock)
   open(filename.gsub(".sim",".polygon.geojson"),"w") do |json|
      json.write(geojson)
   end
end