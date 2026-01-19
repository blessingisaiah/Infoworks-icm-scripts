# ============================================================
# InfoWorks ICM Ruby Script – QA/QC
# Purpose: Check duplicate conduits by geometry
# Author: Blessing Isaiah
# Date: 2026-01-04
# ICM Version: 2024.5
# ============================================================

require 'time'  # For timestamp formatting

net = WSApplication.current_network
TOL = 0.01 # metres

links = net.row_objects('hw_conduit')

# Hash to group conduits by rounded coordinates of US and DS nodes
coord_hash = {}

links.each do |link|
  us_node = net.row_object('hw_node', link.us_node_id)
  ds_node = net.row_object('hw_node', link.ds_node_id)
  next if us_node.nil? || ds_node.nil?

  key = [
    (us_node.x / TOL).round,
    (us_node.y / TOL).round,
    (ds_node.x / TOL).round,
    (ds_node.y / TOL).round
  ]

  coord_hash[key] ||= []
  coord_hash[key] << link
end

# Output duplicates
puts "Duplicate Conduits by Geometry"
puts "Conduit_ID, US_Node, DS_Node"
puts "--------------------------------"
duplicate_count = 0
coord_hash.each do |key, list|
  next if list.size < 2
  duplicate_count += list.size
  list.each do |link|
    puts "#{link.id}, #{link.us_node_id}, #{link.ds_node_id}"
  end
  puts "----"
end

puts "\nTotal duplicate conduits found: #{duplicate_count}"

# ============================================================
# Final Completion Message with Timestamp
# ============================================================
current_time = Time.now.strftime("%Y-%m-%d %H:%M:%S")
puts "\n==============================================="
puts "Processing complete. Outputs generated successfully."
puts "Run timestamp: #{current_time}"
puts "Developed by Blessing Isaiah"
puts "==============================================="
