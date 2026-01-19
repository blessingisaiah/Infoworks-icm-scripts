# ============================================================
# InfoWorks ICM Ruby Script – QA/QC
# Purpose: Check duplicate manholes
# Author: Blessing Isaiah
# Date: 2026-01-06
# ICM Version: 2024.5
# ============================================================

require 'time'  # Needed for timestamp formatting

net = WSApplication.current_network
# Tolerance in metres (0.01 = 1 cm)
TOL = 0.01
nodes = net.row_objects('hw_node')
# Hash to group nodes by rounded coordinates
coord_hash = {}
nodes.each do |node|
  x = node.x
  y = node.y
  next if x.nil? || y.nil?
  # Round coordinates to tolerance
  key = [
    (x / TOL).round,
    (y / TOL).round
  ]
  coord_hash[key] ||= []
  coord_hash[key] << node
end

# Output duplicates
puts "Duplicate Nodes Report"
puts "Node_Type, Node_ID, X, Y"
puts "-----------------------------------------------"
duplicate_count = 0
coord_hash.each do |key, node_list|
  next if node_list.size < 2   # Only duplicates
  duplicate_count += node_list.size
  node_list.each do |node|
    puts "#{node.node_type}, #{node.id}, #{node.x.round(3)}, #{node.y.round(3)}"
  end
  puts "----"
end
puts "\nTotal duplicate nodes found: #{duplicate_count}"

# ============================================================
# Final Completion Message with Timestamp
# ============================================================
current_time = Time.now.strftime("%Y-%m-%d %H:%M:%S")
puts "\n==============================================="
puts "Processing complete. Outputs generated successfully."
puts "Run timestamp: #{current_time}"
puts "Developed by Blessing Isaiah"
puts "==============================================="
