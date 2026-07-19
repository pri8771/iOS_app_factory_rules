#!/usr/bin/env ruby
# frozen_string_literal: true

require "yaml"
require "fileutils"

screens_path = ARGV[0] || "quality/ui/screens.yaml"
journeys_path = ARGV[1] || "quality/ui/journeys.yaml"
out_dir = ARGV[2] || "quality/ui/generated"

screens = YAML.safe_load(File.read(screens_path), aliases: false)
journeys = YAML.safe_load(File.read(journeys_path), aliases: false)
product = journeys.fetch("product")
app_id = ENV.fetch("MAESTRO_APP_ID")
FileUtils.mkdir_p(out_dir)

journeys.fetch("journeys", []).each do |journey|
  lines = ["appId: #{app_id}", "---"]
  journey.fetch("steps", []).each do |step|
    if step["launchApp"]
      lines << "- launchApp"
    elsif step["assertVisible"]
      lines << "- assertVisible:"
      lines << "    id: #{step['assertVisible']}"
    elsif step["tapOn"]
      lines << "- tapOn:"
      lines << "    id: #{step['tapOn']}"
    elsif step["inputText"]
      lines << "- inputText: #{step['inputText'].inspect}"
    else
      warn "Unsupported step in #{journey['id']}: #{step.inspect}"
    end
  end
  filename = journey.fetch("id").downcase.gsub(/[^a-z0-9]+/, "-") + ".yaml"
  File.write(File.join(out_dir, filename), lines.join("\n") + "\n")
end

# Generate one shallow screen-contract flow for required elements.
screens.fetch("screens", []).each do |screen|
  next if screen.fetch("enterFrom", screen.dig("navigation", "enterFrom") || []).empty? && screen["id"] != "SCREEN-HOME"
  lines = ["appId: #{app_id}", "---", "- launchApp"]
  lines << "- assertVisible:"
  lines << "    id: #{screen.fetch('rootIdentifier')}"
  screen.fetch("requiredElements", []).each do |element|
    lines << "- assertVisible:"
    lines << "    id: #{element.fetch('identifier')}"
  end
  filename = "screen-#{screen.fetch('id').downcase.gsub(/[^a-z0-9]+/, '-')}.yaml"
  File.write(File.join(out_dir, filename), lines.join("\n") + "\n")
end

puts "Generated Maestro flows for #{product} in #{out_dir}"
