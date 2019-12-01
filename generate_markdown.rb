#!/usr/bin/env ruby

require 'bundler/inline'

# Templating language handler
require 'erb'

# XLSX parsing
require 'rubyXL'

MissingField = Class.new(RuntimeError)

SpreadsheetParser = Struct.new(:workbook) do

  Park = Struct.new(:name)
  Stop = Struct.new(:week_number, :location_name, :park, :description)

  StopParser = Struct.new(:number, :sheet) do
    def stop
      Stop.new(number,
        require_row('Location Name')[1],
        park,
        require_row('Description')[1])
    end

    def park
      row = require_row('Park')[1..-1]
      Park.new(*row)
    end

    def require_row(key)
      get_first_row(key).tap do |value|
        if value.nil?
          raise MissingField, "Sheet #{sheet.sheet_name} should have field #{key}."
        end
      end
    end

    def get_first_row(key)
      rows.find {|row| row[0] == key }
    end

    def rows
      @rows ||= sheet.map {|row| row.cells.map(&:value) }
    end
  end

  def to_h
    { stops: stops }
  end

  def stops
    (1..8).map do |number|
      sheet = workbook["Week #{number}"]

      if !sheet.nil?
        StopParser.new(number, sheet).stop
      end
    end.compact
  end
end

workbook = RubyXL::Parser.parse(ARGV[0] || abort('.xlsx input path must be given'))
template = ERB.new(File.read(ARGV[1] || abort('.md.erb template path must be given')))

begin
  parsed_spreadsheet_data = SpreadsheetParser.new(workbook).to_h
rescue MissingField => e
  abort(e.message)
end

STDERR.puts parsed_spreadsheet_data.inspect

File.write(ARGV[2] || abort('.md output path must be given'),
  template.result_with_hash(parsed_spreadsheet_data))
