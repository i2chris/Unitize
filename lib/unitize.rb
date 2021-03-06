require 'liner'
require 'memoizable'
require 'parslet'
require 'signed_multiset'
require 'yaml'
require 'bigdecimal'
require 'dentaku'

require 'unitize/version'
require 'unitize/base'
require 'unitize/compatible'
require 'unitize/number'
require 'unitize/expression'
require 'unitize/scale'
require 'unitize/functional'
require 'unitize/measurement'
require 'unitize/atom'
require 'unitize/prefix'
require 'unitize/term'
require 'unitize/unit'
require 'unitize/search'
require 'unitize/errors'

require "models/measurement_type"
require "models/measurement_unit"
require "models/measurement_prefix"

# Unitize is a library for performing mathematical operations and conversions
# on all units defined by the [Unified Code for Units of Measure(UCUM).
module Unitize

  # Determine if a given string is a valid unit expression
  # @param expression [String]
  # @return [true, false]
  # @api public
  def self.valid?(expression)
    begin
      !!Unitize::Expression.decompose(expression)
    rescue ExpressionError
      false
    end
  end

  # The system path for the installed gem
  # @api private
  def self.path
    @path ||= File.dirname(File.dirname(__FILE__))
  end

  # A helper to get the location of a yaml data file
  # @api private
  def self.data_file(key)
    File.join path, 'data', "#{key}.yaml"
  end

  def self.preload
    Unitize::Prefix.all
    Unitize::Atom.all
  end

end

# Measurement initializer shorthand. Use this to instantiate new measurements.
# @param first [Numeric, String] Either a numeric value or a unit expression
# @param last [String, Nil] Either a unit expression, or nil
# @return [Unitize::Measurement]
# @example
#   Unitize(20, 'mile') # => #<Unitize::Measurement 20 mile>
#   Unitize('km') # => #<Unitize::Measurement 1 km>
# @api public
def Unitize(*args)
  Unitize::Measurement.new(*args)
end
