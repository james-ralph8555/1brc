# Data Types

enum arrow::Type::type
Main data type enumeration.

This enumeration provides a quick way to interrogate the category of
a DataType instance.

*Values:*

- enumerator NA
  A NULL type having no physical storage.
- enumerator BOOL
  Boolean as 1 bit, LSB bit-packed ordering.
- enumerator UINT8
  Unsigned 8-bit little-endian integer.
- enumerator INT8
  Signed 8-bit little-endian integer.
- enumerator UINT16
  Unsigned 16-bit little-endian integer.
- enumerator INT16
  Signed 16-bit little-endian integer.
- enumerator UINT32
  Unsigned 32-bit little-endian integer.
- enumerator INT32
  Signed 32-bit little-endian integer.
- enumerator UINT64
  Unsigned 64-bit little-endian integer.
- enumerator INT64
  Signed 64-bit little-endian integer.
- enumerator HALF_FLOAT
  2-byte floating point value
- enumerator FLOAT
  4-byte floating point value
- enumerator DOUBLE
  8-byte floating point value
- enumerator STRING
  UTF8 variable-length string as List<Char>
- enumerator BINARY
  Variable-length bytes (no guarantee of UTF8-ness)
- enumerator FIXED_SIZE_BINARY
  Fixed-size binary. Each value occupies the same number of bytes.
- enumerator DATE32
  int32_t days since the UNIX epoch
- enumerator DATE64
  int64_t milliseconds since the UNIX epoch
- enumerator TIMESTAMP
  Exact timestamp encoded with int64 since UNIX epoch Default unit
  millisecond.
- enumerator TIME32
  Time as signed 32-bit integer, representing either seconds or
  milliseconds since midnight.
- enumerator TIME64
  Time as signed 64-bit integer, representing either microseconds
  or nanoseconds since midnight.
- enumerator INTERVAL_MONTHS
  YEAR_MONTH interval in SQL style.
- enumerator INTERVAL_DAY_TIME
  DAY_TIME interval in SQL style.
- enumerator DECIMAL128
  Precision- and scale-based decimal type with 128 bits.
- enumerator DECIMAL
  Defined for backward-compatibility.
- enumerator DECIMAL256
  Precision- and scale-based decimal type with 256 bits.
- enumerator LIST
  A list of some logical data type.
- enumerator STRUCT
  Struct of logical types.
- enumerator SPARSE_UNION
  Sparse unions of logical types.
- enumerator DENSE_UNION
  Dense unions of logical types.
- enumerator DICTIONARY
  Dictionary-encoded type, also called "categorical" or "factor"
  in other programming languages.

  Holds the dictionary value type but not the dictionary itself,
  which is part of the ArrayData struct
- enumerator MAP
  Map, a repeated struct logical type.
- enumerator EXTENSION
  Custom data type, implemented by user.
- enumerator FIXED_SIZE_LIST
  Fixed size list of some logical type.
- enumerator DURATION
  Measure of elapsed time in either seconds, milliseconds,
  microseconds or nanoseconds.
- enumerator LARGE_STRING
  Like STRING, but with 64-bit offsets.
- enumerator LARGE_BINARY
  Like BINARY, but with 64-bit offsets.
- enumerator LARGE_LIST
  Like LIST, but with 64-bit offsets.
- enumerator INTERVAL_MONTH_DAY_NANO
  Calendar interval type with three fields.
- enumerator RUN_END_ENCODED
  Run-end encoded data.
- enumerator STRING_VIEW
  String (UTF8) view type with 4-byte prefix and inline small
  string optimization.
- enumerator BINARY_VIEW
  Bytes view type with 4-byte prefix and inline small string
  optimization.
- enumerator LIST_VIEW
  A list of some logical data type represented by offset and size.
- enumerator LARGE_LIST_VIEW
  Like LIST_VIEW, but with 64-bit offsets and sizes.
- enumerator DECIMAL32
  Precision- and scale-based decimal type with 32 bits.
- enumerator DECIMAL64
  Precision- and scale-based decimal type with 64 bits.
- enumerator MAX_ID

class DataType : public std::enable_shared_from_this<DataType>, public arrow::detail::Fingerprintable, public arrow::util::EqualityComparable<DataType>
Base class for all data types.

Data types in this library are all *logical*. They can be expressed
as either a primitive physical type (bytes or bits of some fixed
size), a nested type consisting of other data types, or another data
type (e.g. a timestamp encoded as an int64).

Simple datatypes may be entirely described by their
Type::type id, but complex datatypes are usually parametric.

Subclassed by arrow::BaseBinaryType,
arrow::BinaryViewType,
arrow::ExtensionType,
arrow::FixedWidthType, arrow::NestedType,
arrow::NullType

Public Functions

- bool Equals(const DataType &other, bool check_metadata = false) const
  Return whether the types are equal.

  Types that are logically convertible from one to another (e.g.
  List<UInt8> and Binary) are NOT equal.
- bool Equals(const std::shared_ptr<DataType> &other, bool check_metadata = false) const
  Return whether the types are equal.
- inline const std::shared_ptr<Field> &field(int i) const
  Return the child field at index i.
- inline const FieldVector &fields() const
  Return the children fields associated with this type.
- inline int num_fields() const
  Return the number of children fields associated with this type.
- Status Accept(TypeVisitor *visitor) const
  Apply the
  TypeVisitor::Visit()
  method specialized to the data type.
- virtual std::string ToString(bool show_metadata = false) const = 0
  A string representation of the type, including any children.
- size_t Hash() const
  Return hash value (excluding metadata in child fields)
- virtual std::string name() const = 0
  A string name of the type, omitting any child fields.

  **Since**
  0.7.0
- virtual DataTypeLayout layout() const = 0
  Return the data type layout.

  Children are not included.

  Note
  Experimental API
- inline constexpr Type::type id() const
  Return the type category.
- inline virtual Type::type storage_id() const
  Return the type category of the storage type.
- inline virtual int32_t byte_width() const
  Returns the type's fixed byte width, if any.

  Returns -1 for non-fixed-width types, and should only be used
  for subclasses of FixedWidthType
- inline virtual int bit_width() const
  Returns the type's fixed bit width, if any.

  Returns -1 for non-fixed-width types, and should only be used
  for subclasses of FixedWidthType

## Factory functions

These functions are recommended for creating data types. They may return
new objects or existing singletons, depending on the type requested.

- const std::shared_ptr<DataType> &null()
  Return a NullType instance.
- const std::shared_ptr<DataType> &boolean()
  Return a BooleanType instance.
- const std::shared_ptr<DataType> &int8()
  Return a Int8Type instance.
- const std::shared_ptr<DataType> &int16()
  Return a Int16Type instance.
- const std::shared_ptr<DataType> &int32()
  Return a Int32Type instance.
- const std::shared_ptr<DataType> &int64()
  Return a Int64Type instance.
- const std::shared_ptr<DataType> &uint8()
  Return a UInt8Type instance.
- const std::shared_ptr<DataType> &uint16()
  Return a UInt16Type instance.
- const std::shared_ptr<DataType> &uint32()
  Return a UInt32Type instance.
- const std::shared_ptr<DataType> &uint64()
  Return a UInt64Type instance.
- const std::shared_ptr<DataType> &float16()
  Return a HalfFloatType instance.
- const std::shared_ptr<DataType> &float32()
  Return a FloatType instance.
- const std::shared_ptr<DataType> &float64()
  Return a DoubleType instance.
- const std::shared_ptr<DataType> &utf8()
  Return a StringType instance.
- const std::shared_ptr<DataType> &utf8_view()
  Return a StringViewType instance.
- const std::shared_ptr<DataType> &large_utf8()
  Return a LargeStringType instance.
- const std::shared_ptr<DataType> &binary()
  Return a BinaryType instance.
- const std::shared_ptr<DataType> &binary_view()
  Return a BinaryViewType instance.
- const std::shared_ptr<DataType> &large_binary()
  Return a LargeBinaryType instance.
- const std::shared_ptr<DataType> &date32()
  Return a Date32Type instance.
- const std::shared_ptr<DataType> &date64()
  Return a Date64Type instance.
- std::shared_ptr<DataType> fixed_size_binary(int32_t byte_width)
  Create a
  FixedSizeBinaryType
  instance.
- std::shared_ptr<DataType> decimal(int32_t precision, int32_t scale)
  Create a DecimalType instance
  depending on the precision.

  If the precision is greater than 38, a
  Decimal256Type is returned,
  otherwise a Decimal128Type.

  Deprecated: prefer `smallest_decimal` instead.
- std::shared_ptr<DataType> smallest_decimal(int32_t precision, int32_t scale)
  Create a the smallest DecimalType
  instance depending on precision.

  Given the requested precision and scale, the smallest
  DecimalType which is able to
  represent that precision will be returned. As different bit-widths
  for decimal types are added, the concrete data type returned here
  can potentially change accordingly.
- std::shared_ptr<DataType> decimal32(int32_t precision, int32_t scale)
  Create a Decimal32Type instance.
- std::shared_ptr<DataType> decimal64(int32_t precision, int32_t scale)
  Create a Decimal64Type instance.
- std::shared_ptr<DataType> decimal128(int32_t precision, int32_t scale)
  Create a Decimal128Type instance.
- std::shared_ptr<DataType> decimal256(int32_t precision, int32_t scale)
  Create a Decimal256Type instance.
- std::shared_ptr<DataType> list(std::shared_ptr<Field> value_type)
  Create a ListType instance from its
  child Field type.
- std::shared_ptr<DataType> list(std::shared_ptr<DataType> value_type)
  Create a ListType instance from its
  child DataType.
- std::shared_ptr<DataType> large_list(std::shared_ptr<Field> value_type)
  Create a LargeListType instance
  from its child Field type.
- std::shared_ptr<DataType> large_list(std::shared_ptr<DataType> value_type)
  Create a LargeListType instance
  from its child DataType.
- std::shared_ptr<DataType> list_view(std::shared_ptr<DataType> value_type)
  Create a ListViewType instance.
- std::shared_ptr<DataType> list_view(std::shared_ptr<Field> value_type)
  Create a ListViewType instance
  from its child Field type.
- std::shared_ptr<DataType> large_list_view(std::shared_ptr<DataType> value_type)
  Create a LargetListViewType instance.
- std::shared_ptr<DataType> large_list_view(std::shared_ptr<Field> value_type)
  Create a LargetListViewType instance from its child
  Field type.
- std::shared_ptr<DataType> map(std::shared_ptr<DataType> key_type, std::shared_ptr<DataType> item_type, bool keys_sorted = false)
  Create a MapType instance from its key
  and value DataTypes.
- std::shared_ptr<DataType> map(std::shared_ptr<DataType> key_type, std::shared_ptr<Field> item_field, bool keys_sorted = false)
  Create a MapType instance from its key
  DataType and value field.

  The field override is provided to communicate nullability of the
  value.
- std::shared_ptr<DataType> fixed_size_list(std::shared_ptr<Field> value_type, int32_t list_size)
  Create a FixedSizeListType
  instance from its child Field type.
- std::shared_ptr<DataType> fixed_size_list(std::shared_ptr<DataType> value_type, int32_t list_size)
  Create a FixedSizeListType
  instance from its child DataType.
- std::shared_ptr<DataType> duration(TimeUnit::type unit)
  Return a Duration instance (naming use _type to avoid namespace
  conflict with built in time classes).
- std::shared_ptr<DataType> day_time_interval()
  Return a
  DayTimeIntervalType
  instance.
- std::shared_ptr<DataType> month_interval()
  Return a MonthIntervalType
  instance.
- std::shared_ptr<DataType> month_day_nano_interval()
  Return a
  MonthDayNanoIntervalType
  instance.
- std::shared_ptr<DataType> timestamp(TimeUnit::type unit)
  Create a TimestampType instance
  from its unit.
- std::shared_ptr<DataType> timestamp(TimeUnit::type unit, const std::string &timezone)
  Create a TimestampType instance
  from its unit and timezone.
- std::shared_ptr<DataType> time32(TimeUnit::type unit)
  Create a 32-bit time type instance.

  Unit can be either SECOND or MILLI
- std::shared_ptr<DataType> time64(TimeUnit::type unit)
  Create a 64-bit time type instance.

  Unit can be either MICRO or NANO
- std::shared_ptr<DataType> struct_(const FieldVector &fields)
  Create a StructType instance.
- std::shared_ptr<DataType> struct_(std::initializer_list<std::pair<std::string, std::shared_ptr<DataType>>> fields)
  Create a StructType instance from
  (name, type) pairs.
- std::shared_ptr<DataType> run_end_encoded(std::shared_ptr<DataType> run_end_type, std::shared_ptr<DataType> value_type)
  Create a RunEndEncodedType
  instance.
- std::shared_ptr<DataType> sparse_union(FieldVector child_fields, std::vector<int8_t> type_codes = {})
  Create a SparseUnionType
  instance.
- std::shared_ptr<DataType> sparse_union(const ArrayVector &children, std::vector<std::string> field_names = {}, std::vector<int8_t> type_codes = {})
  Create a SparseUnionType
  instance.
- std::shared_ptr<DataType> dense_union(FieldVector child_fields, std::vector<int8_t> type_codes = {})
  Create a DenseUnionType
  instance.
- std::shared_ptr<DataType> dense_union(const ArrayVector &children, std::vector<std::string> field_names = {}, std::vector<int8_t> type_codes = {})
  Create a DenseUnionType
  instance.
- std::shared_ptr<DataType> dictionary(const std::shared_ptr<DataType> &index_type, const std::shared_ptr<DataType> &dict_type, bool ordered = false)
  Create a DictionaryType instance.

  Parameters:
  - **index_type** -- **[in]** the type of the dictionary
    indices (must be a signed integer)
  - **dict_type** -- **[in]** the type of the values in the
    variable dictionary
  - **ordered** -- **[in]** true if the order of the
    dictionary values has semantic meaning and should be
    preserved where possible

## Concrete type subclasses

### Primitive

class NullType : public arrow::DataType
Concrete type class for always-null data.

Public Functions

- virtual std::string ToString(bool show_metadata = false) const override
  A string representation of the type, including any children.
- inline virtual DataTypeLayout layout() const override
  Return the data type layout.

  Children are not included.

  Note
  Experimental API
- inline virtual std::string name() const override
  A string name of the type, omitting any child fields.

  **Since**
  0.7.0

class BooleanType : public arrow::detail::CTypeImpl<BooleanType, PrimitiveCType, Type::BOOL, bool>
Concrete type class for boolean data.

Public Functions

- inline virtual int bit_width() const final
  Returns the type's fixed bit width, if any.

  Returns -1 for non-fixed-width types, and should only be used
  for subclasses of FixedWidthType
- inline virtual DataTypeLayout layout() const override
  Return the data type layout.

  Children are not included.

  Note
  Experimental API

class UInt8Type : public arrow::detail::IntegerTypeImpl<UInt8Type, Type::UINT8, uint8_t>

*#include <arrow/type.h>*

Concrete type class for unsigned 8-bit integer data.

class Int8Type : public arrow::detail::IntegerTypeImpl<Int8Type, Type::INT8, int8_t>

*#include <arrow/type.h>*

Concrete type class for signed 8-bit integer data.

class UInt16Type : public arrow::detail::IntegerTypeImpl<UInt16Type, Type::UINT16, uint16_t>

*#include <arrow/type.h>*

Concrete type class for unsigned 16-bit integer data.

class Int16Type : public arrow::detail::IntegerTypeImpl<Int16Type, Type::INT16, int16_t>

*#include <arrow/type.h>*

Concrete type class for signed 16-bit integer data.

class UInt32Type : public arrow::detail::IntegerTypeImpl<UInt32Type, Type::UINT32, uint32_t>

*#include <arrow/type.h>*

Concrete type class for unsigned 32-bit integer data.

class Int32Type : public arrow::detail::IntegerTypeImpl<Int32Type, Type::INT32, int32_t>

*#include <arrow/type.h>*

Concrete type class for signed 32-bit integer data.

class UInt64Type : public arrow::detail::IntegerTypeImpl<UInt64Type, Type::UINT64, uint64_t>

*#include <arrow/type.h>*

Concrete type class for unsigned 64-bit integer data.

class Int64Type : public arrow::detail::IntegerTypeImpl<Int64Type, Type::INT64, int64_t>

*#include <arrow/type.h>*

Concrete type class for signed 64-bit integer data.

class HalfFloatType : public arrow::detail::CTypeImpl<HalfFloatType, FloatingPointType, Type::HALF_FLOAT, uint16_t>

*#include <arrow/type.h>*

Concrete type class for 16-bit floating-point data.

class FloatType : public arrow::detail::CTypeImpl<FloatType, FloatingPointType, Type::FLOAT, float>

*#include <arrow/type.h>*

Concrete type class for 32-bit floating-point data (C "float")

class DoubleType : public arrow::detail::CTypeImpl<DoubleType, FloatingPointType, Type::DOUBLE, double>

*#include <arrow/type.h>*

Concrete type class for 64-bit floating-point data (C "double")

class DecimalType : public arrow::FixedSizeBinaryType

*#include <arrow/type.h>*

Base type class for (fixed-size) decimal data.

Subclassed by
arrow::Decimal128Type,
arrow::Decimal256Type,
arrow::Decimal32Type,
arrow::Decimal64Type

Public Static Functions

- static Result<std::shared_ptr<DataType>> Make(Type::type type_id, int32_t precision, int32_t scale)
  Constructs concrete decimal types.
- static int32_t DecimalSize(int32_t precision)
  Returns the number of bytes needed for precision.

  precision must be >= 1

class Decimal32Type : public arrow::DecimalType

*#include <arrow/type.h>*

Concrete type class for 32-bit decimal data.

Arrow decimals are fixed-point decimal numbers encoded as a scaled
integer. The precision is the number of significant digits that the
decimal type can represent; the scale is the number of digits after
the decimal point (note the scale can be negative).

As an example, `Decimal32Type(7, 3)` can exactly represent the
numbers 1234.567 and -1234.567 (encoded internally as the 32-bit
integers 1234567 and -1234567, respectively), but neither 12345.67
nor 123.4567.

Decimal32Type has a maximum
precision of 9 significant digits (also available as
Decimal32Type::kMaxPrecision). If higher precision is needed,
consider using Decimal64Type,
Decimal128Type or
Decimal256Type.

Public Functions

- explicit Decimal32Type(int32_t precision, int32_t scale)
  Decimal32Type constructor that
  aborts on invalid input.
- virtual std::string ToString(bool show_metadata = false) const override
  A string representation of the type, including any children.
- inline virtual std::string name() const override
  A string name of the type, omitting any child fields.

  **Since**
  0.7.0

Public Static Functions

- static Result<std::shared_ptr<DataType>> Make(int32_t precision, int32_t scale)
  Decimal32Type constructor that
  returns an error on invalid input.

class Decimal64Type : public arrow::DecimalType

*#include <arrow/type.h>*

Concrete type class for 64-bit decimal data.

Arrow decimals are fixed-point decimal numbers encoded as a scaled
integer. The precision is the number of significant digits that the
decimal type can represent; the scale is the number of digits after
the decimal point (note the scale can be negative).

As an example, `Decimal64Type(7, 3)` can exactly represent the
numbers 1234.567 and -1234.567 (encoded internally as the 64-bit
integers 1234567 and -1234567, respectively), but neither 12345.67
nor 123.4567.

Decimal64Type has a maximum
precision of 18 significant digits (also available as
Decimal64Type::kMaxPrecision). If higher precision is needed,
consider using Decimal128Type or
Decimal256Type.

Public Functions

- explicit Decimal64Type(int32_t precision, int32_t scale)
  Decimal32Type constructor that
  aborts on invalid input.
- virtual std::string ToString(bool show_metadata = false) const override
  A string representation of the type, including any children.
- inline virtual std::string name() const override
  A string name of the type, omitting any child fields.

  **Since**
  0.7.0

Public Static Functions

- static Result<std::shared_ptr<DataType>> Make(int32_t precision, int32_t scale)
  Decimal32Type constructor that
  returns an error on invalid input.

class Decimal128Type : public arrow::DecimalType

*#include <arrow/type.h>*

Concrete type class for 128-bit decimal data.

Arrow decimals are fixed-point decimal numbers encoded as a scaled
integer. The precision is the number of significant digits that the
decimal type can represent; the scale is the number of digits after
the decimal point (note the scale can be negative).

As an example, `Decimal128Type(7, 3)` can exactly represent the
numbers 1234.567 and -1234.567 (encoded internally as the 128-bit
integers 1234567 and -1234567, respectively), but neither 12345.67
nor 123.4567.

Decimal128Type has a maximum
precision of 38 significant digits (also available as
Decimal128Type::kMaxPrecision). If higher precision is needed,
consider using Decimal256Type.

Public Functions

- explicit Decimal128Type(int32_t precision, int32_t scale)
  Decimal128Type constructor
  that aborts on invalid input.
- virtual std::string ToString(bool show_metadata = false) const override
  A string representation of the type, including any children.
- inline virtual std::string name() const override
  A string name of the type, omitting any child fields.

  **Since**
  0.7.0

Public Static Functions

- static Result<std::shared_ptr<DataType>> Make(int32_t precision, int32_t scale)
  Decimal128Type constructor
  that returns an error on invalid input.

class Decimal256Type : public arrow::DecimalType

*#include <arrow/type.h>*

Concrete type class for 256-bit decimal data.

Arrow decimals are fixed-point decimal numbers encoded as a scaled
integer. The precision is the number of significant digits that the
decimal type can represent; the scale is the number of digits after
the decimal point (note the scale can be negative).

Decimal256Type has a maximum
precision of 76 significant digits. (also available as
Decimal256Type::kMaxPrecision).

For most use cases, the maximum precision offered by
Decimal128Type is sufficient, and
it will result in a more compact and more efficient encoding.

Public Functions

- explicit Decimal256Type(int32_t precision, int32_t scale)
  Decimal256Type constructor
  that aborts on invalid input.
- virtual std::string ToString(bool show_metadata = false) const override
  A string representation of the type, including any children.
- inline virtual std::string name() const override
  A string name of the type, omitting any child fields.

  **Since**
  0.7.0

Public Static Functions

- static Result<std::shared_ptr<DataType>> Make(int32_t precision, int32_t scale)
  Decimal256Type constructor
  that returns an error on invalid input.

### Temporal

enum arrow::TimeUnit::type
The unit for a time or timestamp
DataType.

*Values:*

- enumerator SECOND
- enumerator MILLI
- enumerator MICRO
- enumerator NANO

std::ostream &operator<<(std::ostream &os, TimeUnit::type unit)

std::ostream &operator<<(std::ostream &os, DayTimeIntervalType::DayMilliseconds interval)

std::ostream &operator<<(std::ostream &os, MonthDayNanoIntervalType::MonthDayNanos interval)

class TemporalType : public arrow::FixedWidthType

*#include <arrow/type.h>*

Base type for all date and time types.

Subclassed by arrow::DateType,
arrow::DurationType,
arrow::IntervalType,
arrow::TimeType,
arrow::TimestampType

Public Functions

- inline virtual DataTypeLayout layout() const override
  Return the data type layout.

  Children are not included.

  Note
  Experimental API

class DateType : public arrow::TemporalType

*#include <arrow/type.h>*

Base type class for date data.

Subclassed by arrow::Date32Type,
arrow::Date64Type

class Date32Type : public arrow::DateType

*#include <arrow/type.h>*

Concrete type class for 32-bit date data (as number of days since
UNIX epoch)

Public Functions

- inline virtual int bit_width() const override
  Returns the type's fixed bit width, if any.

  Returns -1 for non-fixed-width types, and should only be used
  for subclasses of FixedWidthType
- virtual std::string ToString(bool show_metadata = false) const override
  A string representation of the type, including any children.
- inline virtual std::string name() const override
  A string name of the type, omitting any child fields.

  **Since**
  0.7.0

class Date64Type : public arrow::DateType

*#include <arrow/type.h>*

Concrete type class for 64-bit date data (as number of milliseconds
since UNIX epoch)

Public Functions

- inline virtual int bit_width() const override
  Returns the type's fixed bit width, if any.

  Returns -1 for non-fixed-width types, and should only be used
  for subclasses of FixedWidthType
- virtual std::string ToString(bool show_metadata = false) const override
  A string representation of the type, including any children.
- inline virtual std::string name() const override
  A string name of the type, omitting any child fields.

  **Since**
  0.7.0

class TimeType : public arrow::TemporalType, public arrow::ParametricType

*#include <arrow/type.h>*

Base type class for time data.

Subclassed by arrow::Time32Type,
arrow::Time64Type

class Time32Type : public arrow::TimeType

*#include <arrow/type.h>*

Concrete type class for 32-bit time data (as number of seconds or
milliseconds since midnight)

Public Functions

- inline virtual int bit_width() const override
  Returns the type's fixed bit width, if any.

  Returns -1 for non-fixed-width types, and should only be used
  for subclasses of FixedWidthType
- virtual std::string ToString(bool show_metadata = false) const override
  A string representation of the type, including any children.
- inline virtual std::string name() const override
  A string name of the type, omitting any child fields.

  **Since**
  0.7.0

class Time64Type : public arrow::TimeType

*#include <arrow/type.h>*

Concrete type class for 64-bit time data (as number of microseconds
or nanoseconds since midnight)

Public Functions

- inline virtual int bit_width() const override
  Returns the type's fixed bit width, if any.

  Returns -1 for non-fixed-width types, and should only be used
  for subclasses of FixedWidthType
- virtual std::string ToString(bool show_metadata = false) const override
  A string representation of the type, including any children.
- inline virtual std::string name() const override
  A string name of the type, omitting any child fields.

  **Since**
  0.7.0

class TimestampType : public arrow::TemporalType, public arrow::ParametricType

*#include <arrow/type.h>*

Concrete type class for datetime data (as number of seconds,
milliseconds, microseconds or nanoseconds since UNIX epoch)

If supplied, the timezone string should take either the form (i)
"Area/Location", with values drawn from the names in the IANA Time
Zone Database (such as "Europe/Zurich"); or (ii) "(+/-)HH:MM"
indicating an absolute offset from GMT (such as "-08:00"). To
indicate a native UTC timestamp, one of the strings "UTC", "Etc/UTC"
or "+00:00" should be used.

If any non-empty string is supplied as the timezone for a
TimestampType, then the Arrow
field containing that timestamp type (and by extension the column
associated with such a field) is considered "timezone-aware". The
integer arrays that comprise a timezone-aware column must contain
UTC normalized datetime values, regardless of the contents of their
timezone string. More precisely, (i) the producer of a
timezone-aware column must populate its constituent arrays with
valid UTC values (performing offset conversions from non-UTC values
if necessary); and (ii) the consumer of a timezone-aware column may
assume that the column's values are directly comparable (that is,
with no offset adjustment required) to the values of any other
timezone-aware column or to any other valid UTC datetime value
(provided all values are expressed in the same units).

If a TimestampType is constructed
without a timezone (or, equivalently, if the timezone supplied is an
empty string) then the resulting Arrow field (column) is considered
"timezone-naive". The producer of a timezone-naive column may
populate its constituent integer arrays with datetime values from
any timezone; the consumer of a timezone-naive column should make no
assumptions about the interoperability or comparability of the
values of such a column with those of any other timestamp column or
datetime value.

If a timezone-aware field contains a recognized timezone, its values
may be localized to that locale upon display; the values of
timezone-naive fields must always be displayed "as is", with no
localization performed on them.

Public Functions

- inline virtual int bit_width() const override
  Returns the type's fixed bit width, if any.

  Returns -1 for non-fixed-width types, and should only be used
  for subclasses of FixedWidthType
- virtual std::string ToString(bool show_metadata = false) const override
  A string representation of the type, including any children.
- inline virtual std::string name() const override
  A string name of the type, omitting any child fields.

  **Since**
  0.7.0

class IntervalType : public arrow::TemporalType, public arrow::ParametricType

*#include <arrow/type.h>*

Subclassed by
arrow::DayTimeIntervalType,
arrow::MonthDayNanoIntervalType,
arrow::MonthIntervalType

class MonthIntervalType : public arrow::IntervalType

*#include <arrow/type.h>*

Represents a number of months.

Type representing a number of months. Corresponds to YearMonth type
in Schema.fbs (years are defined as 12 months).

Public Functions

- inline virtual int bit_width() const override
  Returns the type's fixed bit width, if any.

  Returns -1 for non-fixed-width types, and should only be used
  for subclasses of FixedWidthType
- inline virtual std::string ToString(bool show_metadata = false) const override
  A string representation of the type, including any children.
- inline virtual std::string name() const override
  A string name of the type, omitting any child fields.

  **Since**
  0.7.0

class DayTimeIntervalType : public arrow::IntervalType

*#include <arrow/type.h>*

Represents a number of days and milliseconds (fraction of day).

Public Functions

- inline virtual int bit_width() const override
  Returns the type's fixed bit width, if any.

  Returns -1 for non-fixed-width types, and should only be used
  for subclasses of FixedWidthType
- inline virtual std::string ToString(bool show_metadata = false) const override
  A string representation of the type, including any children.
- inline virtual std::string name() const override
  A string name of the type, omitting any child fields.

  **Since**
  0.7.0

struct DayMilliseconds

*#include <arrow/type.h>*

class MonthDayNanoIntervalType : public arrow::IntervalType

*#include <arrow/type.h>*

Represents a number of months, days and nanoseconds between two
dates.

All fields are independent from one another.

Public Functions

- inline virtual int bit_width() const override
  Returns the type's fixed bit width, if any.

  Returns -1 for non-fixed-width types, and should only be used
  for subclasses of FixedWidthType
- inline virtual std::string ToString(bool show_metadata = false) const override
  A string representation of the type, including any children.
- inline virtual std::string name() const override
  A string name of the type, omitting any child fields.

  **Since**
  0.7.0

struct MonthDayNanos

*#include <arrow/type.h>*

class DurationType : public arrow::TemporalType, public arrow::ParametricType

*#include <arrow/type.h>*

Represents an elapsed time without any relation to a calendar
artifact.

Public Functions

- inline virtual int bit_width() const override
  Returns the type's fixed bit width, if any.

  Returns -1 for non-fixed-width types, and should only be used
  for subclasses of FixedWidthType
- virtual std::string ToString(bool show_metadata = false) const override
  A string representation of the type, including any children.
- inline virtual std::string name() const override
  A string name of the type, omitting any child fields.

  **Since**
  0.7.0

### Binary-like

class BinaryType : public arrow::BaseBinaryType

*#include <arrow/type.h>*

Concrete type class for variable-size binary data.

Subclassed by arrow::StringType

Public Functions

- inline virtual DataTypeLayout layout() const override
  Return the data type layout.

  Children are not included.

  Note
  Experimental API
- virtual std::string ToString(bool show_metadata = false) const override
  A string representation of the type, including any children.
- inline virtual std::string name() const override
  A string name of the type, omitting any child fields.

  **Since**
  0.7.0

class BinaryViewType : public arrow::DataType

*#include <arrow/type.h>*

Concrete type class for variable-size binary view data.

Subclassed by
arrow::StringViewType

Public Functions

- inline virtual DataTypeLayout layout() const override
  Return the data type layout.

  Children are not included.

  Note
  Experimental API
- virtual std::string ToString(bool show_metadata = false) const override
  A string representation of the type, including any children.
- inline virtual std::string name() const override
  A string name of the type, omitting any child fields.

  **Since**
  0.7.0

union c_type

*#include <arrow/type.h>*

Variable length string or binary with inline optimization for
small values (12 bytes or fewer).

This is similar to std::string_view except limited in size to
INT32_MAX and at least the first four bytes of the string are
copied inline (accessible without pointer dereference). This
inline prefix allows failing comparisons early. Furthermore when
dealing with short strings the CPU cache working set is reduced
since many can be inline.

This union supports two states:

- Entirely inlined string data

  |----|--------------|
  ^    ^
  |    |
  size    in-line string data, zero padded

- Reference into a buffer

  |----|----|----|----|
  ^    ^    ^    ^
  |    |    |    `------.
  size    |    |           |
  prefix   |           |
  buffer index   |
  offset in buffer

Adapted from TU Munich's UmbraDB
[1](https://db.in.tum.de/~freitag/papers/p29-neumann-cidr20.pdf),
Velox, DuckDB.

Alignment to 64 bits enables an aligned load of the size and
prefix into a single 64 bit integer, which is useful to the
comparison fast path.

Public Functions

- inline int32_t size() const
  The number of bytes viewed.
- inline bool is_inline() const
  True if the view's data is entirely stored inline.
- inline const uint8_t *inline_data() const &
  Return a pointer to the inline data of a view.

  For inline views, this points to the entire data of the
  view. For other views, this points to the 4 byte prefix.
- const uint8_t *inline_data() && = delete

Public Members

- int32_t size
- std::array<uint8_t, kInlineSize> data
- struct arrow::BinaryViewType::c_type::[anonymous] inlined
- std::array<uint8_t, kPrefixSize> prefix
- int32_t buffer_index
- int32_t offset
- struct arrow::BinaryViewType::c_type::[anonymous] ref

class LargeBinaryType : public arrow::BaseBinaryType

*#include <arrow/type.h>*

Concrete type class for large variable-size binary data.

Subclassed by
arrow::LargeStringType

Public Functions

- inline virtual DataTypeLayout layout() const override
  Return the data type layout.

  Children are not included.

  Note
  Experimental API
- virtual std::string ToString(bool show_metadata = false) const override
  A string representation of the type, including any children.
- inline virtual std::string name() const override
  A string name of the type, omitting any child fields.

  **Since**
  0.7.0

class StringType : public arrow::BinaryType

*#include <arrow/type.h>*

Concrete type class for variable-size string data, utf8-encoded.

Public Functions

- virtual std::string ToString(bool show_metadata = false) const override
  A string representation of the type, including any children.
- inline virtual std::string name() const override
  A string name of the type, omitting any child fields.

  **Since**
  0.7.0

class StringViewType : public arrow::BinaryViewType

*#include <arrow/type.h>*

Concrete type class for variable-size string data, utf8-encoded.

Public Functions

- virtual std::string ToString(bool show_metadata = false) const override
  A string representation of the type, including any children.
- inline virtual std::string name() const override
  A string name of the type, omitting any child fields.

  **Since**
  0.7.0

class LargeStringType : public arrow::LargeBinaryType

*#include <arrow/type.h>*

Concrete type class for large variable-size string data,
utf8-encoded.

Public Functions

- virtual std::string ToString(bool show_metadata = false) const override
  A string representation of the type, including any children.
- inline virtual std::string name() const override
  A string name of the type, omitting any child fields.

  **Since**
  0.7.0

class FixedSizeBinaryType : public arrow::FixedWidthType, public arrow::ParametricType

*#include <arrow/type.h>*

Concrete type class for fixed-size binary data.

Subclassed by arrow::DecimalType

Public Functions

- virtual std::string ToString(bool show_metadata = false) const override
  A string representation of the type, including any children.
- inline virtual std::string name() const override
  A string name of the type, omitting any child fields.

  **Since**
  0.7.0
- inline virtual DataTypeLayout layout() const override
  Return the data type layout.

  Children are not included.

  Note
  Experimental API
- inline virtual int byte_width() const override
  Returns the type's fixed byte width, if any.

  Returns -1 for non-fixed-width types, and should only be used
  for subclasses of FixedWidthType
- virtual int bit_width() const override
  Returns the type's fixed bit width, if any.

  Returns -1 for non-fixed-width types, and should only be used
  for subclasses of FixedWidthType

### Nested

class BaseListType : public arrow::NestedType

*#include <arrow/type.h>*

Base class for all variable-size list data types.

Subclassed by
arrow::FixedSizeListType,
arrow::LargeListType,
arrow::LargeListViewType,
arrow::ListType,
arrow::ListViewType

class ListType : public arrow::BaseListType

*#include <arrow/type.h>*

Concrete type class for list data.

List data is nested data where each value is a variable number of
child items. Lists can be recursively nested, for example
list(list(int32)).

Subclassed by arrow::MapType

Public Functions

- inline virtual DataTypeLayout layout() const override
  Return the data type layout.

  Children are not included.

  Note
  Experimental API
- virtual std::string ToString(bool show_metadata = false) const override
  A string representation of the type, including any children.
- inline virtual std::string name() const override
  A string name of the type, omitting any child fields.

  **Since**
  0.7.0

class LargeListType : public arrow::BaseListType

*#include <arrow/type.h>*

Concrete type class for large list data.

LargeListType is like
ListType but with 64-bit rather than
32-bit offsets.

Public Functions

- inline virtual DataTypeLayout layout() const override
  Return the data type layout.

  Children are not included.

  Note
  Experimental API
- virtual std::string ToString(bool show_metadata = false) const override
  A string representation of the type, including any children.
- inline virtual std::string name() const override
  A string name of the type, omitting any child fields.

  **Since**
  0.7.0

class ListViewType : public arrow::BaseListType

*#include <arrow/type.h>*

Type class for array of list views.

Public Functions

- inline virtual DataTypeLayout layout() const override
  Return the data type layout.

  Children are not included.

  Note
  Experimental API
- virtual std::string ToString(bool show_metadata = false) const override
  A string representation of the type, including any children.
- inline virtual std::string name() const override
  A string name of the type, omitting any child fields.

  **Since**
  0.7.0

class LargeListViewType : public arrow::BaseListType

*#include <arrow/type.h>*

Concrete type class for large list-view data.

LargeListViewType is like
ListViewType but with 64-bit
rather than 32-bit offsets and sizes.

Public Functions

- inline virtual DataTypeLayout layout() const override
  Return the data type layout.

  Children are not included.

  Note
  Experimental API
- virtual std::string ToString(bool show_metadata = false) const override
  A string representation of the type, including any children.
- inline virtual std::string name() const override
  A string name of the type, omitting any child fields.

  **Since**
  0.7.0

class MapType : public arrow::ListType

*#include <arrow/type.h>*

Concrete type class for map data.

Map data is nested data where each value is a variable number of
key-item pairs. Its physical representation is the same as a list of
`{key, item}` structs.

Maps can be recursively nested, for example map(utf8, map(utf8,
int32)).

Public Functions

- virtual std::string ToString(bool show_metadata = false) const override
  A string representation of the type, including any children.
- inline virtual std::string name() const override
  A string name of the type, omitting any child fields.

  **Since**
  0.7.0

class FixedSizeListType : public arrow::BaseListType

*#include <arrow/type.h>*

Concrete type class for fixed size list data.

Public Functions

- inline virtual DataTypeLayout layout() const override
  Return the data type layout.

  Children are not included.

  Note
  Experimental API
- virtual std::string ToString(bool show_metadata = false) const override
  A string representation of the type, including any children.
- inline virtual std::string name() const override
  A string name of the type, omitting any child fields.

  **Since**
  0.7.0

class StructType : public arrow::NestedType

*#include <arrow/type.h>*

Concrete type class for struct data.

Public Functions

- inline virtual DataTypeLayout layout() const override
  Return the data type layout.

  Children are not included.

  Note
  Experimental API
- virtual std::string ToString(bool show_metadata = false) const override
  A string representation of the type, including any children.
- inline virtual std::string name() const override
  A string name of the type, omitting any child fields.

  **Since**
  0.7.0
- std::shared_ptr<Field> GetFieldByName(const std::string &name) const
  Returns null if name not found.
- FieldVector GetAllFieldsByName(const std::string &name) const
  Return all fields having this name.
- int GetFieldIndex(const std::string &name) const
  Returns -1 if name not found or if there are multiple fields
  having the same name.
- std::vector<int> GetAllFieldIndices(const std::string &name) const
  Return the indices of all fields having this name in sorted
  order.
- Result<std::shared_ptr<StructType>> AddField(int i, const std::shared_ptr<Field> &field) const
  Create a new StructType with
  field added at given index.
- Result<std::shared_ptr<StructType>> RemoveField(int i) const
  Create a new StructType by
  removing the field at given index.
- Result<std::shared_ptr<StructType>> SetField(int i, const std::shared_ptr<Field> &field) const
  Create a new StructType by
  changing the field at given index.

class UnionType : public arrow::NestedType

*#include <arrow/type.h>*

Base type class for union data.

Subclassed by
arrow::DenseUnionType,
arrow::SparseUnionType

Public Functions

- virtual DataTypeLayout layout() const override
  Return the data type layout.

  Children are not included.

  Note
  Experimental API
- virtual std::string ToString(bool show_metadata = false) const override
  A string representation of the type, including any children.
- inline const std::vector<int8_t> &type_codes() const
  The array of logical type ids.

  For example, the first type in the union might be denoted by the
  id 5 (instead of 0).
- inline const std::vector<int> &child_ids() const
  An array mapping logical type ids to physical child ids.

class SparseUnionType : public arrow::UnionType

*#include <arrow/type.h>*

Concrete type class for sparse union data.

A sparse union is a nested type where each logical value is taken
from a single child. A buffer of 8-bit type ids indicates which
child a given logical value is to be taken from.

In a sparse union, each child array should have the same length as
the union array, regardless of the actual number of union values
that refer to it.

Note that, unlike most other types, unions don't have a top-level
validity bitmap.

Public Functions

- inline virtual std::string name() const override
  A string name of the type, omitting any child fields.

  **Since**
  0.7.0

class DenseUnionType : public arrow::UnionType

*#include <arrow/type.h>*

Concrete type class for dense union data.

A dense union is a nested type where each logical value is taken
from a single child, at a specific offset. A buffer of 8-bit type
ids indicates which child a given logical value is to be taken from,
and a buffer of 32-bit offsets indicates at which physical position
in the given child array the logical value is to be taken from.

Unlike a sparse union, a dense union allows encoding only the child
array values which are actually referred to by the union array. This
is counterbalanced by the additional footprint of the offsets
buffer, and the additional indirection cost when looking up values.

Note that, unlike most other types, unions don't have a top-level
validity bitmap.

Public Functions

- inline virtual std::string name() const override
  A string name of the type, omitting any child fields.

  **Since**
  0.7.0

class RunEndEncodedType : public arrow::NestedType

*#include <arrow/type.h>*

Type class for run-end encoded data.

Public Functions

- inline virtual DataTypeLayout layout() const override
  Return the data type layout.

  Children are not included.

  Note
  Experimental API
- virtual std::string ToString(bool show_metadata = false) const override
  A string representation of the type, including any children.
- inline virtual std::string name() const override
  A string name of the type, omitting any child fields.

  **Since**
  0.7.0

### Dictionary-encoded

class DictionaryType : public arrow::FixedWidthType

Dictionary-encoded value type with data-dependent dictionary.

Indices are represented by any integer types.

Public Functions

- virtual std::string ToString(bool show_metadata = false) const override
  A string representation of the type, including any children.
- inline virtual std::string name() const override
  A string name of the type, omitting any child fields.

  **Since**
  0.7.0
- virtual int bit_width() const override
  Returns the type's fixed bit width, if any.

  Returns -1 for non-fixed-width types, and should only be used
  for subclasses of FixedWidthType
- virtual DataTypeLayout layout() const override
  Return the data type layout.

  Children are not included.

  Note
  Experimental API

### Extension types

class ExtensionType : public arrow::DataType

The base class for custom / user-defined types.

Subclassed by
arrow::extension::Bool8Type,
arrow::extension::FixedShapeTensorType,
arrow::extension::JsonExtensionType,
arrow::extension::OpaqueType,
arrow::extension::UuidType

Public Functions

- inline const std::shared_ptr<DataType> &storage_type() const
  The type of array used to represent this extension type's data.
- inline virtual Type::type storage_id() const override
  Return the type category of the storage type.
- virtual DataTypeLayout layout() const override
  Return the data type layout.

  Children are not included.

  Note
  Experimental API
- virtual std::string ToString(bool show_metadata = false) const override
  A string representation of the type, including any children.
- inline virtual std::string name() const override
  A string name of the type, omitting any child fields.

  **Since**
  0.7.0
- inline virtual int32_t byte_width() const override
  Returns the type's fixed byte width, if any.

  Returns -1 for non-fixed-width types, and should only be used
  for subclasses of FixedWidthType
- inline virtual int bit_width() const override
  Returns the type's fixed bit width, if any.

  Returns -1 for non-fixed-width types, and should only be used
  for subclasses of FixedWidthType
- virtual std::string extension_name() const = 0
  Unique name of extension type used to identify type for
  serialization.

  Returns:
  the string name of the extension
- virtual bool ExtensionEquals(const ExtensionType &other) const = 0
  Determine if two instances of the same extension types are
  equal.

  Invoked from
  ExtensionType::Equals

  Parameters:
  **other** -- **[in]** the type to compare this type with

  Returns:
  bool true if type instances are equal
- virtual std::shared_ptr<Array> MakeArray(std::shared_ptr<ArrayData> data) const = 0
  Wrap built-in Array type in a
  user-defined
  ExtensionArray
  instance.

  Parameters:
  **data** -- **[in]** the physical storage for the
  extension type
- virtual Result<std::shared_ptr<DataType>> Deserialize(std::shared_ptr<DataType> storage_type, const std::string &serialized_data) const = 0
  Create an instance of the
  ExtensionType given the actual
  storage type and the serialized representation.

  Parameters:
  - **storage_type** -- **[in]** the physical storage type
    of the extension
  - **serialized_data** -- **[in]** the serialized
    representation produced by Serialize
- virtual std::string Serialize() const = 0
  Create a serialized representation of the extension type's
  metadata.

  The storage type will be handled automatically in IPC code paths

  Returns:
  the serialized representation

Public Static Functions

- static std::shared_ptr<Array> WrapArray(const std::shared_ptr<DataType> &ext_type, const std::shared_ptr<Array> &storage)
  Wrap the given storage array as an extension array.
- static std::shared_ptr<ChunkedArray> WrapArray(const std::shared_ptr<DataType> &ext_type, const std::shared_ptr<ChunkedArray> &storage)
  Wrap the given chunked storage array as a chunked extension
  array.

## Fields and Schemas

std::shared_ptr<Field> field(std::string name, std::shared_ptr<DataType> type, bool nullable = true, std::shared_ptr<const KeyValueMetadata> metadata = NULLPTR)
Create a Field instance.

Parameters:
- **name** -- the field name
- **type** -- the field value type
- **nullable** -- whether the values are nullable, default
  true
- **metadata** -- any custom key-value metadata, default null

std::shared_ptr<Field> field(std::string name, std::shared_ptr<DataType> type, std::shared_ptr<const KeyValueMetadata> metadata)
Create a Field instance with metadata.

The field will be assumed to be nullable.

Parameters:
- **name** -- the field name
- **type** -- the field value type
- **metadata** -- any custom key-value metadata

std::shared_ptr<Schema> schema(FieldVector fields, std::shared_ptr<const KeyValueMetadata> metadata = NULLPTR)
Create a Schema instance.

Parameters:
- **fields** -- the schema's fields
- **metadata** -- any custom key-value metadata, default null

Returns:
schema shared_ptr to Schema

std::shared_ptr<Schema> schema(std::initializer_list<std::pair<std::string, std::shared_ptr<DataType>>> fields, std::shared_ptr<const KeyValueMetadata> metadata = NULLPTR)
Create a Schema instance from (name, type)
pairs.

The schema's fields will all be nullable with no associated
metadata.

Parameters:
- **fields** -- (name, type) pairs of the schema's fields
- **metadata** -- any custom key-value metadata, default null

Returns:
schema shared_ptr to Schema

std::shared_ptr<Schema> schema(FieldVector fields, Endianness endianness, std::shared_ptr<const KeyValueMetadata> metadata = NULLPTR)
Create a Schema instance.

Parameters:
- **fields** -- the schema's fields
- **endianness** -- the endianness of the data
- **metadata** -- any custom key-value metadata, default null

Returns:
schema shared_ptr to Schema

std::shared_ptr<Schema> schema(std::initializer_list<std::pair<std::string, std::shared_ptr<DataType>>> fields, Endianness endianness, std::shared_ptr<const KeyValueMetadata> metadata = NULLPTR)
Create a Schema instance.

The schema's fields will all be nullable with no associated
metadata.

Parameters:
- **fields** -- (name, type) pairs of the schema's fields
- **endianness** -- the endianness of the data
- **metadata** -- any custom key-value metadata, default null

Returns:
schema shared_ptr to Schema

class Field : public arrow::detail::Fingerprintable, public arrow::util::EqualityComparable<Field>
The combination of a field name and data type, with optional
metadata.

Fields are used to describe the individual constituents of a nested
DataType or a
Schema.

A field's metadata is represented by a
KeyValueMetadata instance,
which holds arbitrary key-value pairs.

Public Functions

- inline std::shared_ptr<const KeyValueMetadata> metadata() const
  Return the field's attached metadata.
- bool HasMetadata() const
  Return whether the field has non-empty metadata.
- std::shared_ptr<Field> WithMetadata(const std::shared_ptr<const KeyValueMetadata> &metadata) const
  Return a copy of this field with the given metadata attached to
  it.
- std::shared_ptr<Field> WithMergedMetadata(const std::shared_ptr<const KeyValueMetadata> &metadata) const
  EXPERIMENTAL: Return a copy of this field with the given
  metadata merged with existing metadata (any colliding keys will
  be overridden by the passed metadata)
- std::shared_ptr<Field> RemoveMetadata() const
  Return a copy of this field without any metadata attached to it.
- std::shared_ptr<Field> WithType(const std::shared_ptr<DataType> &type) const
  Return a copy of this field with the replaced type.
- std::shared_ptr<Field> WithName(const std::string &name) const
  Return a copy of this field with the replaced name.
- std::shared_ptr<Field> WithNullable(bool nullable) const
  Return a copy of this field with the replaced nullability.
- Result<std::shared_ptr<Field>> MergeWith(const Field &other, MergeOptions options = MergeOptions::Defaults()) const
  Merge the current field with a field of the same name.

  The two fields must be compatible, i.e:
  - have the same name
  - have the same type, or of compatible types according to
    `options`.

  The metadata of the current field is preserved; the metadata of
  the other field is discarded.
- bool Equals(const Field &other, bool check_metadata = false) const
  Indicate if fields are equals.

  Parameters:
  - **other** -- **[in]** field to check equality with.
  - **check_metadata** -- **[in]** controls if it should
    check for metadata equality.

  Returns:
  true if fields are equal, false otherwise.
- bool IsCompatibleWith(const Field &other) const
  Indicate if fields are compatibles.

  See the criteria of MergeWith.

  Returns:
  true if fields are compatible, false otherwise.
- std::string ToString(bool show_metadata = false) const
  Return a string representation ot the field.

  Parameters:
  **show_metadata** -- **[in]** when true, if
  KeyValueMetadata is
  non-empty, print keys and values in the output
- inline const std::string &name() const
  Return the field name.
- inline const std::shared_ptr<DataType> &type() const
  Return the field data type.
- inline bool nullable() const
  Return whether the field is nullable.

struct MergeOptions : public arrow::util::ToStringOstreamable<MergeOptions>
Options that control the behavior of `MergeWith`.

Options are to be added to allow type conversions, including
integer widening, promotion from integer to float, or conversion
to or from boolean.

Public Functions

- std::string ToString() const
  Get a human-readable representation of the options.

Public Members

- bool promote_nullability = true
  If true, a Field of
  NullType can be unified with a
  Field of another type.

  The unified field will be of the other type and become
  nullable. Nullability will be promoted to the looser option
  (nullable if one is not nullable).
- bool promote_decimal = false
  Allow a decimal to be unified with another decimal of the
  same width, adjusting scale and precision as appropriate.

  May fail if the adjustment is not possible.
- bool promote_decimal_to_float = false
  Allow a decimal to be promoted to a float.

  The float type will not itself be promoted (e.g.
  Decimal128 +
  Float32 = Float32).
- bool promote_integer_to_decimal = false
  Allow an integer to be promoted to a decimal.

  May fail if the decimal has insufficient precision to
  accommodate the integer (see promote_numeric_width).
- bool promote_integer_to_float = false
  Allow an integer of a given bit width to be promoted to a
  float; the result will be a float of an equal or greater bit
  width to both of the inputs.

  Examples:
  - int8 + float32 = float32
  - int32 + float32 = float64
  - int32 + float64 = float64 Because an int32 cannot always
    be represented exactly in the 24 bits of a float32
    mantissa.
- bool promote_integer_sign = false
  Allow an unsigned integer of a given bit width to be
  promoted to a signed integer that fits into the signed type:
  uint + int16 = int16 When widening is needed, set
  promote_numeric_width to true: uint16 + int16 = int32.
- bool promote_numeric_width = false
  Allow an integer, float, or decimal of a given bit width to
  be promoted to an equivalent type of a greater bit width.
- bool promote_binary = false
  Allow strings to be promoted to binary types.

  Promotion of fixed size binary types to variable sized
  formats, and binary to large binary, and string to large
  string.
- bool promote_temporal_unit = false
  Second to millisecond, Time32 to Time64, Time32(SECOND) to
  Time32(MILLI), etc.
- bool promote_list = false
  Allow promotion from a list to a large-list and from a
  fixed-size list to a variable sized list.
- bool promote_dictionary = false
  Unify dictionary index types and dictionary value types.
- bool promote_dictionary_ordered = false
  Allow merging ordered and non-ordered dictionaries.

  The result will be ordered if and only if both inputs are
  ordered.

Public Static Functions

- static inline MergeOptions Defaults()
  Get default options. Only
  NullType will be merged with
  other types.
- static MergeOptions Permissive()
  Get permissive options.

  All options are enabled, except promote_dictionary_ordered.

class Schema : public arrow::detail::Fingerprintable, public arrow::util::EqualityComparable<Schema>, public arrow::util::ToStringOstreamable<Schema>
Sequence of arrow::Field objects describing
the columns of a record batch or table data structure.

Public Functions

- bool Equals(const Schema &other, bool check_metadata = false) const
  Returns true if all of the schema fields are equal.
- std::shared_ptr<Schema> WithEndianness(Endianness endianness) const
  Set endianness in the schema.

  Returns:
  new Schema
- Endianness endianness() const
  Return endianness in the schema.
- bool is_native_endian() const
  Indicate if endianness is equal to platform-native endianness.
- int num_fields() const
  Return the number of fields (columns) in the schema.
- const std::shared_ptr<Field> &field(int i) const
  Return the ith schema element. Does not boundscheck.
- std::shared_ptr<Field> GetFieldByName(std::string_view name) const
  Returns null if name not found.
- FieldVector GetAllFieldsByName(std::string_view name) const
  Return the indices of all fields having this name in sorted
  order.
- int GetFieldIndex(std::string_view name) const
  Returns -1 if name not found.
- std::vector<int> GetAllFieldIndices(std::string_view name) const
  Return the indices of all fields having this name.
- Status CanReferenceFieldByName(std::string_view name) const
  Indicate if field named `name` can be found unambiguously in the
  schema.
- Status CanReferenceFieldsByNames(const std::vector<std::string> &names) const
  Indicate if fields named `names` can be found unambiguously in
  the schema.
- const std::shared_ptr<const KeyValueMetadata> &metadata() const
  The custom key-value metadata, if any.

  Returns:
  metadata may be null
- std::string ToString(bool show_metadata = false) const
  Render a string representation of the schema suitable for
  debugging.

  Parameters:
  **show_metadata** -- **[in]** when true, if
  KeyValueMetadata is
  non-empty, print keys and values in the output
- Result<std::shared_ptr<Schema>> WithNames(const std::vector<std::string> &names) const
  Replace field names with new names.

  Parameters:
  **names** -- **[in]** new names

  Returns:
  new Schema
- std::shared_ptr<Schema> WithMetadata(const std::shared_ptr<const KeyValueMetadata> &metadata) const
  Replace key-value metadata with new metadata.

  Parameters:
  **metadata** -- **[in]** new
  KeyValueMetadata

  Returns:
  new Schema
- std::shared_ptr<Schema> RemoveMetadata() const
  Return copy of Schema without the
  KeyValueMetadata.
- bool HasMetadata() const
  Indicate that the Schema has non-empty
  KevValueMetadata.
- bool HasDistinctFieldNames() const
  Indicate that the Schema has distinct
  field names.

class KeyValueMetadata
A container for key-value pair type metadata. Not thread-safe.

### Helpers for looking up fields

class FieldPath
Represents a path to a nested field using indices of child fields.

For example, given indices {5, 9, 3} the field would be retrieved
with schema->field(5)->type()->field(9)->type()->field(3)

Attempting to retrieve a child field using a
FieldPath which is not valid for a
given schema will raise an error. Invalid FieldPaths include:

- an index is out of range
- the path is empty (note: a default constructed
  FieldPath will be empty)

FieldPaths provide a number of accessors for drilling down to
potentially nested children. They are overloaded for convenience to
support Schema (returns a field),
DataType (returns a child field),
Field (returns a child field of this
field's type) Array (returns a
child array), RecordBatch
(returns a column).

Public Functions

- FieldPath() = default
- inline FieldPath(std::vector<int> indices)
- inline FieldPath(std::initializer_list<int> indices)
- std::string ToString() const
- size_t hash() const
- inline bool empty() const
- inline bool operator==(const FieldPath &other) const
- inline bool operator!=(const FieldPath &other) const
- inline const std::vector<int> &indices() const
- inline int operator[](size_t i) const
- inline std::vector<int>::const_iterator begin() const
- inline std::vector<int>::const_iterator end() const
- Result<std::shared_ptr<Field>> Get(const Schema &schema) const
  Retrieve the referenced child Field
  from a Schema,
  Field, or
  DataType.
- Result<std::shared_ptr<Field>> Get(const Field &field) const
- Result<std::shared_ptr<Field>> Get(const DataType &type) const
- Result<std::shared_ptr<Field>> Get(const FieldVector &fields) const
- Result<std::shared_ptr<Array>> Get(const RecordBatch &batch) const
  Retrieve the referenced column from a
  RecordBatch or
  Table.
- Result<std::shared_ptr<ChunkedArray>> Get(const Table &table) const
- Result<std::shared_ptr<Array>> Get(const Array &array) const
  Retrieve the referenced child from an
  Array or
  ArrayData.
- Result<std::shared_ptr<ArrayData>> Get(const ArrayData &data) const
- Result<std::shared_ptr<ChunkedArray>> Get(const ChunkedArray &chunked_array) const
  Retrieve the referenced child from a
  ChunkedArray.
- Result<std::shared_ptr<Array>> GetFlattened(const Array &array, MemoryPool *pool = NULLPTR) const
  Retrieve the referenced child/column from an
  Array,
  ArrayData,
  ChunkedArray,
  RecordBatch, or
  Table.

  Unlike
  `FieldPath::Get`,
  these variants are not zero-copy and the retrieved child's null
  bitmap is ANDed with its ancestors'
- Result<std::shared_ptr<ArrayData>> GetFlattened(const ArrayData &data, MemoryPool *pool = NULLPTR) const
- Result<std::shared_ptr<ChunkedArray>> GetFlattened(const ChunkedArray &chunked_array, MemoryPool *pool = NULLPTR) const
- Result<std::shared_ptr<Array>> GetFlattened(const RecordBatch &batch, MemoryPool *pool = NULLPTR) const
- Result<std::shared_ptr<ChunkedArray>> GetFlattened(const Table &table, MemoryPool *pool = NULLPTR) const

Public Static Functions

- static Result<std::shared_ptr<Schema>> GetAll(const Schema &schema, const std::vector<FieldPath> &paths)

struct Hash

Public Functions

- inline size_t operator()(const FieldPath &path) const

class FieldRef : public arrow::util::EqualityComparable<FieldRef>
Descriptor of a (potentially nested) field within a schema.

Unlike FieldPath (which exclusively
uses indices of child fields), FieldRef
may reference a field by name. It is intended to replace parameters
like `int field_index` and
`const std::string& field_name`; it can be implicitly
constructed from either a field index or a name.

Nested fields can be referenced as well. Given schema({field("a",
struct_({field("n",
null())})),
field("b",
int32())})

the following all indicate the nested field named "n":
FieldRef ref1(0, 0);
FieldRef ref2("a", 0);
FieldRef ref3("a", "n");
FieldRef ref4(0, "n");
ARROW_ASSIGN_OR_RAISE(FieldRef ref5,
FieldRef::FromDotPath(".a[0]"));

FieldPaths matching a FieldRef are
retrieved using the member function FindAll. Multiple matches are
possible because field names may be duplicated within a schema. For
example: Schema a_is_ambiguous({field("a",
int32()),
field("a",
float32())});
auto matches =
FieldRef("a").FindAll(a_is_ambiguous);
assert(matches.size() == 2);
assert(matches[0].Get(a_is_ambiguous)->Equals(a_is_ambiguous.field(0)));
assert(matches[1].Get(a_is_ambiguous)->Equals(a_is_ambiguous.field(1)));

Convenience accessors are available which raise a helpful error if
the field is not found or ambiguous, and for immediately calling
FieldPath::Get
to retrieve any matching children: auto maybe_match =
FieldRef("struct",
"field_i32").FindOneOrNone(schema); auto maybe_column =
FieldRef("struct",
"field_i32").GetOne(some_table);

Public Types

template<typename T>
using GetType = decltype(std::declval<FieldPath>().Get(std::declval<T>()).ValueOrDie())

Public Functions

- FieldRef() = default
- FieldRef(FieldPath indices)
  Construct a FieldRef using a string
  of indices.

  The reference will be retrieved as:
  schema.fields[self.indices[0]].type.fields[self.indices[1]]
  ...

  Empty indices are not valid.
- inline FieldRef(std::string name)
  Construct a by-name FieldRef.

  Multiple fields may match a by-name
  FieldRef: [f for f in
  schema.fields where f.name == self.name]
- inline FieldRef(const char *name)
- inline FieldRef(int index)
  Equivalent to a single index string of indices.
- inline explicit FieldRef(std::vector<FieldRef> refs)
  Construct a nested FieldRef.
- template<typename A0, typename A1, typename ...A>
  inline FieldRef(A0 &&a0, A1 &&a1, A&&... a)
  Convenience constructor for nested FieldRefs: each argument will
  be used to construct a FieldRef.
- std::string ToDotPath() const
- inline bool Equals(const FieldRef &other) const
- std::string ToString() const
- size_t hash() const
- inline explicit operator bool() const
- inline bool operator!() const
- inline bool IsFieldPath() const
- inline bool IsName() const
- inline bool IsNested() const
- inline bool IsNameSequence() const
  Return true if this ref is a name or a nested sequence of only
  names.

  Useful for determining if iteration is possible without
  recursion or inner loops
- inline const FieldPath *field_path() const
- inline const std::string *name() const
- inline const std::vector<FieldRef> *nested_refs() const
- std::vector<FieldPath> FindAll(const Schema &schema) const
  Retrieve FieldPath of every child
  field which matches this FieldRef.
- std::vector<FieldPath> FindAll(const Field &field) const
- std::vector<FieldPath> FindAll(const DataType &type) const
- std::vector<FieldPath> FindAll(const FieldVector &fields) const
- std::vector<FieldPath> FindAll(const ArrayData &array) const
  Convenience function which applies FindAll to arg's type or
  schema.
- std::vector<FieldPath> FindAll(const Array &array) const
- std::vector<FieldPath> FindAll(const ChunkedArray &chunked_array) const
- std::vector<FieldPath> FindAll(const RecordBatch &batch) const
- std::vector<FieldPath> FindAll(const Table &table) const
- template<typename T>
  inline Status CheckNonEmpty(const std::vector<FieldPath> &matches, const T &root) const
  Convenience function: raise an error if matches is empty.
- template<typename T>
  inline Status CheckNonMultiple(const std::vector<FieldPath> &matches, const T &root) const
  Convenience function: raise an error if matches contains
  multiple FieldPaths.
- template<typename T>
  inline Result<FieldPath> FindOne(const T &root) const
  Retrieve FieldPath of a single
  child field which matches this
  FieldRef.

  Emit an error if none or multiple match.
- template<typename T>
  inline Result<FieldPath> FindOneOrNone(const T &root) const
  Retrieve FieldPath of a single
  child field which matches this
  FieldRef.

  Emit an error if multiple match. An empty (invalid)
  FieldPath will be returned if none
  match.
- template<typename T>
  inline std::vector<GetType<T>> GetAll(const T &root) const
  Get all children matching this
  FieldRef.
- template<typename T>
  inline Result<std::vector<GetType<T>>> GetAllFlattened(const T &root, MemoryPool *pool = NULLPTR) const
  Get all children matching this
  FieldRef.

  Unlike
  `FieldRef::GetAll`,
  this variant is not zero-copy and the retrieved children's null
  bitmaps are ANDed with their ancestors'
- template<typename T>
  inline Result<GetType<T>> GetOne(const T &root) const
  Get the single child matching this
  FieldRef.

  Emit an error if none or multiple match.
- template<typename T>
  inline Result<GetType<T>> GetOneFlattened(const T &root, MemoryPool *pool = NULLPTR) const
  Get the single child matching this
  FieldRef.

  Unlike
  `FieldRef::GetOne`,
  this variant is not zero-copy and the retrieved child's null
  bitmap is ANDed with its ancestors'
- template<typename T>
  inline Result<GetType<T>> GetOneOrNone(const T &root) const
  Get the single child matching this
  FieldRef.

  Return nullptr if none match, emit an error if multiple match.
- template<typename T>
  inline Result<GetType<T>> GetOneOrNoneFlattened(const T &root, MemoryPool *pool = NULLPTR) const
  Get the single child matching this
  FieldRef.

  Return nullptr if none match, emit an error if multiple match.
  Unlike
  `FieldRef::GetOneOrNone`,
  this variant is not zero-copy and the retrieved child's null
  bitmap is ANDed with its ancestors'

Public Static Functions

- static Result<FieldRef> FromDotPath(const std::string &dot_path)
  Parse a dot path into a FieldRef.

  dot_path = '.' name | '[' digit+ ']' | dot_path+

  Examples: ".alpha" =>
  FieldRef("alpha") "[2]" =>
  FieldRef(2) ".beta[3]" =>
  FieldRef("beta", 3)
  "[5].gamma.delta[7]" =>
  FieldRef(5, "gamma", "delta", 7)
  ".hello world" => FieldRef("hello
  world") R".\[y\]\tho.\" =>
  FieldRef(R"([y]\tho.\)")

  Note: When parsing a name, a '\' preceding any other character
  will be dropped from the resulting name. Therefore if a name
  must contain the characters '.', '\', or '[ 'those must be
  escaped with a preceding '\'.

struct Hash

Public Functions

- inline size_t operator()(const FieldRef &ref) const

## Utilities

class TypeVisitor
Abstract type visitor class.

Subclass this to create a visitor that can be used with the
DataType::Accept()
method.

Public Functions

- virtual ~TypeVisitor() = default
- virtual Status Visit(const NullType &type)
- virtual Status Visit(const BooleanType &type)
- virtual Status Visit(const Int8Type &type)
- virtual Status Visit(const Int16Type &type)
- virtual Status Visit(const Int32Type &type)
- virtual Status Visit(const Int64Type &type)
- virtual Status Visit(const UInt8Type &type)
- virtual Status Visit(const UInt16Type &type)
- virtual Status Visit(const UInt32Type &type)
- virtual Status Visit(const UInt64Type &type)
- virtual Status Visit(const HalfFloatType &type)
- virtual Status Visit(const FloatType &type)
- virtual Status Visit(const DoubleType &type)
- virtual Status Visit(const StringType &type)
- virtual Status Visit(const StringViewType &type)
- virtual Status Visit(const BinaryType &type)
- virtual Status Visit(const BinaryViewType &type)
- virtual Status Visit(const LargeStringType &type)
- virtual Status Visit(const LargeBinaryType &type)
- virtual Status Visit(const FixedSizeBinaryType &type)
- virtual Status Visit(const Date64Type &type)
- virtual Status Visit(const Date32Type &type)
- virtual Status Visit(const Time32Type &type)
- virtual Status Visit(const Time64Type &type)
- virtual Status Visit(const TimestampType &type)
- virtual Status Visit(const MonthDayNanoIntervalType &type)
- virtual Status Visit(const MonthIntervalType &type)
- virtual Status Visit(const DayTimeIntervalType &type)
- virtual Status Visit(const DurationType &type)
- virtual Status Visit(const Decimal32Type &type)
- virtual Status Visit(const Decimal64Type &type)
- virtual Status Visit(const Decimal128Type &type)
- virtual Status Visit(const Decimal256Type &type)
- virtual Status Visit(const ListType &type)
- virtual Status Visit(const LargeListType &type)
- virtual Status Visit(const ListViewType &scalar)
- virtual Status Visit(const LargeListViewType &scalar)
- virtual Status Visit(const MapType &type)
- virtual Status Visit(const FixedSizeListType &type)
- virtual Status Visit(const StructType &type)
- virtual Status Visit(const SparseUnionType &type)
- virtual Status Visit(const DenseUnionType &type)
- virtual Status Visit(const DictionaryType &type)
- virtual Status Visit(const RunEndEncodedType &type)
- virtual Status Visit(const ExtensionType &type)
