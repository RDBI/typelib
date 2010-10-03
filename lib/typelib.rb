# Typelib is a way of checking and converting data. It operates as a "filter
# chain" system which allows it to gradually normalize disparate data into a
# common type. Each chain is optionally a part of a list which allows it to
# provide several paths in a single external execution.
#
# The library is arguably very simple and therefore has simple requirements and
# needs. This is intentional.
#
# Please see TypeLib::Filter and TypeLib::FilterList for more information.
#
module TypeLib
  # A FilterList is a ... list of filters. It includes all the methods that
  # Array contains, plus an additional method -- execute. See
  # TypeLib::Filter.
  class FilterList < Array
    # Execute the checks in this list against +obj+, passing in +addl+
    # if any additional arguments are provided. If the check passes, the
    # conversion is run and the chain supplied to the constructor is
    # followed. If no checks pass, the original item is returned.
    def execute(obj)
      f = find { |filter| filter.check(obj) }
      f ? f.convert(obj) : obj
    end
  end

  # TypeLib::Filter is a way of checking, then optionally converting data
  # based on whether or not the check passes. At that point, an additional
  # TypeLib::FilterList may be provided which indicates that more checks need
  # to be followed with the new data.
  class Filter
    attr_reader :check_proc, :convert_proc, :filters

    # A TypeLib::Filter consists of a check procedure, a conversion procedure,
    # and a TypeLib::FilterList which may be empty. Checks return boolean
    # which indicates whether or not the conversion will be attempted. 
    def initialize(check, convert, filters=FilterList.new)
      @check_proc   = check 
      @convert_proc = convert
      @filters      = filters
    end

    # Check this object against the filter. If additional data is supplied,
    # it will be provided to the Filter#check_proc.
    def check(obj)
      check_proc.call(obj)
    end

    # Convert this object unconditionally. If additional data is supplied,
    # it will be provided to the Filter#convert_proc.
    def convert(obj)
      ret = convert_proc.call(obj)
      filters.execute(ret)
    end

    #
    # Same as TypeLib::FilterList#execute, only just for this filter.
    #
    def execute(obj)
      return convert(obj) if check(obj)
      return obj
    end
  end
end
