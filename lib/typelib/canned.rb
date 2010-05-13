require 'bigdecimal'
require 'datetime'
require 'typelib'

module TypeLib
    module Canned
        def build_strptime_filter(format)
            check = proc do |obj|
                (DateTime.strptime(obj, format).strftime(format) == obj) rescue false 
            end

            convert = proc { |obj| DateTime.strptime(obj, format) }

            return Filter.new(check, convert)
        end

        module Checks
            STR_IS_INT = proc { |obj| obj.kind_of?(String) and obj =~ /^\d+$/ }
            STR_IS_DEC = proc { |obj| obj.kind_of?(String) and obj =~ /^[\d.]+$/ }

            IS_NUMERIC = proc { |obj| obj.kind_of?(Numeric) }
            IS_INTEGER = proc { |obj| obj.kind_of?(Integer) }
        end

        module Conversions
            TO_INTEGER         = proc { |obj| obj.to_i }
            TO_FLOAT           = proc { |obj| obj.to_f }
            TO_STRING          = proc { |obj| obj.to_s }
            TO_BINARY          = proc { |obj| obj.to_s(2) }
            TO_HEX             = proc { |obj| obj.to_s(16) }

            STR_TO_BIGDECIMAL  = proc { |obj| BigDecimal.new(obj.to_s) }
        end

        module Filters
            STR_TO_INT   = Filter.new(STR_IS_INT, TO_INTEGER)
            STR_TO_FLOAT = Filter.new(STR_IS_DEC, TO_FLOAT)
            STR_TO_DEC   = Filter.new(STR_IS_DEC, STR_TO_BIGDECIMAL)

            NUM_TO_STR = Filter.new(IS_NUMERIC, TO_STRING)
            INT_TO_BIN = Filter.new(IS_INTEGER, TO_BINARY)
            INT_TO_HEX = Filter.new(IS_INTEGER, TO_HEX)
        end
    end
end
