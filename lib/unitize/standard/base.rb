require 'unitize/standard/extras'
module Unitize::Standard
  class Base
    include Unitize::Standard::Extras

    attr_accessor :attributes

    def self.local_key
      remote_key
    end

    def self.all
      @all ||= read
    end

    def self.read
      Unitize::Standard.hash[remote_key].inject([]){|a,h| a << self.new(h)}
    end

    def self.hash
      self.all.map(&:to_hash)
    end

    def self.path
      Unitize.data_file(local_key)
    end

    def self.write
      File.open(path, 'w') do |f|
        f.write hash.to_yaml
      end
    end

    def initialize(attributes)
      @attributes = attributes
    end

    def names
      if attributes["name"].respond_to?(:map)
        attributes["name"].map(&:to_s)
      else
        attributes["name"].to_s
      end
    end

    def symbol
      sym = attributes["printSymbol"]
      if sym.is_a?(Hash)
        hash_to_markup(sym)
      elsif sym
        sym.to_s
      end
    end

    def code
      attributes["@Code"]
    end

    def to_hash
      [:name, :symbol, :code].inject({}) do |h,a|
        if v = self.send(a)
          h[a] = v
        end
        h
      end
    end

  end
end