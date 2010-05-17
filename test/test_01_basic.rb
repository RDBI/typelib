require 'rubygems'
gem 'test-unit'
require 'test/unit'

$:.unshift 'lib'
require 'typelib'

class TestBasic < Test::Unit::TestCase
    def test_01_classes
        assert(TypeLib)
        assert(TypeLib::FilterList)
        assert(TypeLib::Filter)
    end

    def test_02_object_properties
        filters = TypeLib::FilterList.new

        assert_respond_to(filters, :[])
        assert_respond_to(filters, :<<)
        assert_respond_to(filters, :execute) 

        check   = proc { }
        convert = proc { }
        filter  = TypeLib::Filter.new(check, convert)

        assert_respond_to(filter, :check_proc)
        assert_respond_to(filter, :convert_proc)
        assert_respond_to(filter, :filters)
        assert_respond_to(filter, :check)
        assert_respond_to(filter, :convert)

        assert_kind_of(Proc, filter.check_proc)
        assert_kind_of(Proc, filter.convert_proc)
        assert_kind_of(TypeLib::FilterList, filter.filters)
    end

    def test_03_basic_conversions
        filters = TypeLib::FilterList.new
        check   = proc { |obj| obj.kind_of?(Integer) }
        convert = proc { |obj| obj }

        check2   = proc { |obj| obj.kind_of?(String) and obj =~ /^\d+$/ }
        convert2 = proc { |obj| Integer(obj) }

        filters << TypeLib::Filter.new(check, convert)
        filters << TypeLib::Filter.new(check2, convert2)

        assert_equal(2, filters.count)
        assert_equal(1, filters.execute(1))
        assert_equal(1, filters.execute("1"))

        10.times do
            x = rand(250000).to_i
            assert_equal(x, filters.execute(x))
            assert_equal(x, filters.execute(x.to_s))
        end

        assert_equal("1.25", filters.execute("1.25"))

        filters << TypeLib::Filter.new(proc { true }, proc { |obj| Integer(obj) })
        assert_raises(ArgumentError) { filters.execute("1.25") }
    end

    def test_04_args
        check   = proc { |obj, *addl| addl[0] }
        convert = proc { |obj, *addl| addl[0] } 
        filter  = TypeLib::Filter.new(check, convert)

        assert(filter.check(true, true))
        assert(!filter.check(true, false))
        assert_equal("fart", filter.convert(true, "fart"))
    end

    def test_05_chains
        filters = TypeLib::FilterList.new

        check   = proc { |obj| obj.kind_of?(Integer) }
        convert = proc { |obj| obj.to_s }

        check2   = proc { |obj| obj.kind_of?(String) and obj =~ /^\d+$/ }
        convert2 = proc { |obj| obj.to_f }

        filters << TypeLib::Filter.new(check, convert, TypeLib::FilterList.new([TypeLib::Filter.new(check2, convert2)]))

        assert_equal(1.0, filters.execute(1))
        assert_kind_of(Float, filters.execute(1))
        assert_equal("1", filters.execute("1"))
    end
end
