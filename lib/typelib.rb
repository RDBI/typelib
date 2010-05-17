require 'delegate'

module TypeLib

    VERSION = "0.0.1"

    class FilterList < DelegateClass(Array)
        def initialize(ary=[])
            @filters = ary
            super(@filters)
        end

        def execute(obj, *addl)
            ret = obj 
            @filters.each do |filter|
                if filter.check(obj, *addl)
                    ret = filter.convert(obj, *addl)
                    break
                end
            end
            return ret
        end
    end

    class Filter
        attr_reader :check_proc, :convert_proc, :filters

        def initialize(check, convert, filters=FilterList.new)
            @check_proc   = check 
            @convert_proc = convert
            @filters      = filters
        end

        def check(obj, *addl)
            check_proc.call(obj, *addl)
        end

        def convert(obj, *addl)
            ret = convert_proc.call(obj, *addl)
            filters.execute(ret, *addl)
        end
    end
end

if __FILE__ == $0
    filters = TypeLib::FilterList.new

    check   = proc { |obj, *addl| obj.kind_of?(Integer) }
    convert = proc { |obj, *addl| obj.to_s }
    
    check2   = proc { |obj| obj.kind_of?(String) and obj =~ /^\d+$/ }
    convert2 = proc { |obj| obj.to_i }

    filters << TypeLib::Filter.new(check2, convert2, TypeLib::FilterList.new([TypeLib::Filter.new(check, convert)]))
    filters << TypeLib::Filter.new(check, convert)

    p filters.execute(1)
    p filters.execute("1")
end
