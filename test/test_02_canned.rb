require 'rubygems'
gem 'test-unit'
require 'test/unit'

$:.unshift 'lib'
require 'typelib'
require 'typelib/canned'

class TestCanned < Test::Unit::TestCase
    include TypeLib::Canned
    include TypeLib::Canned::Filters

    def create_filterlist(arg)
        filters = TypeLib::FilterList.new 
        filters << arg
        return filters
    end

    def test_01_string_to_numeric
        filters = create_filterlist(STR_TO_INT)
        assert_equal(1, filters.execute("1"))
        assert_kind_of(Integer, filters.execute("1"))
        
        filters = create_filterlist(STR_TO_FLOAT)
        assert_equal(1.0, filters.execute("1"))
        assert_kind_of(Float, filters.execute("1"))
        
        filters = create_filterlist(STR_TO_DEC)
        assert_equal(BigDecimal.new("1.0"), filters.execute("1"))
        assert_kind_of(BigDecimal, filters.execute("1"))
    end

    def test_02_numeric_to_string
        filters = create_filterlist(NUM_TO_STR)
        assert_equal("1", filters.execute(1))
        assert_kind_of(String, filters.execute(1))

        filters = create_filterlist(INT_TO_BIN)
        assert_equal("10", filters.execute(2))
        assert_kind_of(String, filters.execute(2))
        
        filters = create_filterlist(INT_TO_HEX)
        assert_equal("a", filters.execute(10))
        assert_kind_of(String, filters.execute(10))

    end

    def test_03_datetime
        filters = create_filterlist(build_strptime_filter("%H:%M:%S%z"))
        time = DateTime.now
        newtime = filters.execute(time.strftime("%H:%M:%S%z"))
        assert_equal(time.to_s, newtime.to_s)

        assert_raises(ArgumentError.new("format must include %z due to DateTime fail")) { build_strptime_filter("%H:%M:%S") } 
    end
end
