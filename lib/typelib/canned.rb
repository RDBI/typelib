require 'bigdecimal'
require 'date'
require 'typelib'

module TypeLib
  # Canned checks are just that -- already written for you.
  module Canned
    #
    # build_strptime_filter works with DateTime objects and a format that
    # you provide. It will build and return a new TypeLib::Filter that can
    # check strings for the format you provide and if they pass, convert
    # them to a DateTime object.
    #
    # Due to limitations in the DateTime system itself, you must include
    # zone information -- if not, you will get a value that is offset to
    # GMT, which is not what DateTime.now and pals will return. An
    # ArgumentError will be raised if you do not supply this in the filter.
    #
    def build_strptime_filter(format)
      if format !~ /%z/
        raise ArgumentError, "format must include %z due to DateTime fail"
      end

      check = proc do |obj|
        (DateTime.strptime(obj, format).strftime(format) == obj) rescue false 
      end

      convert = proc { |obj| DateTime.strptime(obj, format) }

      return Filter.new(check, convert)
    end

    module_function :build_strptime_filter

    # Canned Checks.
    module Checks
      STR_IS_INT = proc { |obj| obj.kind_of?(String) and obj =~ /^\d+$/ }
      STR_IS_DEC = proc { |obj| obj.kind_of?(String) and obj =~ /^[\d.]+$/ }

      IS_NUMERIC = proc { |obj| obj.kind_of?(Numeric) }
      IS_INTEGER = proc { |obj| obj.kind_of?(Integer) }
    end

    # Canned Conversions.
    module Conversions
      TO_INTEGER         = proc { |obj| obj.to_i }
      TO_FLOAT           = proc { |obj| obj.to_f }
      TO_STRING          = proc { |obj| obj.to_s }
      TO_BINARY          = proc { |obj| obj.to_s(2) }
      TO_HEX             = proc { |obj| obj.to_s(16) }

      STR_TO_BIGDECIMAL  = proc { |obj| BigDecimal.new(obj.to_s) }
    end

    # Fully canned filters.
    module Filters
      STR_TO_INT   = Filter.new(Checks::STR_IS_INT, Conversions::TO_INTEGER)
      STR_TO_FLOAT = Filter.new(Checks::STR_IS_DEC, Conversions::TO_FLOAT)
      STR_TO_DEC   = Filter.new(Checks::STR_IS_DEC, Conversions::STR_TO_BIGDECIMAL)

      NUM_TO_STR = Filter.new(Checks::IS_NUMERIC, Conversions::TO_STRING)
      INT_TO_BIN = Filter.new(Checks::IS_INTEGER, Conversions::TO_BINARY)
      INT_TO_HEX = Filter.new(Checks::IS_INTEGER, Conversions::TO_HEX)
    end
  end
end
