# Arrays

## Base classes

### class ArrayStatistics

Statistics for an [Array](#classarrow_1_1_array).

Apache Arrow format doesn't have statistics but data source such as Apache Parquet may have statistics. Statistics associated with data source can be read unified API via this class.

Public Types

*   **ValueType**

    The type for maximum and minimum values.

    If the target value exists, one of them is used. `std::nullopt` is used otherwise.

Public Functions

*   **MinArrowType**(const std::shared_ptr<[DataType](datatype.html#_CPPv4N5arrow8DataTypeE)> &array_type)

    Compute Arrow type of the minimum value.

    If [ValueType](#structarrow_1_1_array_statistics_1a32b5572f78bffc37b5d325de72f2932d) is `std::string`, `array_type` may be used. If `array_type` is a binary-like type such as [arrow::binary](datatype.html#group__type-factories_1ga9f95d4754b8177605a64e4c04b6be9f2) and [arrow::large_utf8](datatype.html#group__type-factories_1gae8979e1c2a0641972da1c1da64f55b42), `array_type` is returned. [arrow::utf8](datatype.html#group__type-factories_1ga89d45fbc5b0c2a67e2ff74b961899a1d) is returned otherwise.

    If [ValueType](#structarrow_1_1_array_statistics_1a32b5572f78bffc37b5d325de72f2932d) isn't `std::string`, `array_type` isn't used.

    Parameters:

    *   **array_type** -- The Arrow type of the associated array.

    Returns:

    [arrow::null](datatype.html#group__type-factories_1ga4fa91684814cd41bf5c0771aa8ff9854) if the minimum value is `std::nullopt`, Arrow type based on [ValueType](#structarrow_1_1_array_statistics_1a32b5572f78bffc37b5d325de72f2932d) of the [min](#structarrow_1_1_array_statistics_1ad499233d8dddab64df29c4e8121a4598) otherwise.

*   **MaxArrowType**(const std::shared_ptr<[DataType](datatype.html#_CPPv4N5arrow8DataTypeE)> &array_type)

    Compute Arrow type of the maximum value.

    If [ValueType](#structarrow_1_1_array_statistics_1a32b5572f78bffc37b5d325de72f2932d) is `std::string`, `array_type` may be used. If `array_type` is a binary-like type such as [arrow::binary](datatype.html#group__type-factories_1ga9f95d4754b8177605a64e4c04b6be9f2) and [arrow::large_utf8](datatype.html#group__type-factories_1gae8979e1c2a0641972da1c1da64f55b42), `array_type` is returned. [arrow::utf8](datatype.html#group__type-factories_1ga89d45fbc5b0c2a67e2ff74b961899a1d) is returned otherwise.

    If [ValueType](#structarrow_1_1_array_statistics_1a32b5572f78bffc37b5d325de72f2932d) isn't `std::string`, `array_type` isn't used.

    Parameters:

    *   **array_type** -- The Arrow type of the associated array.

    Returns:

    [arrow::null](datatype.html#group__type-factories_1ga4fa91684814cd41bf5c0771aa8ff9854) if the maximum value is `std::nullopt`, Arrow type based on [ValueType](#structarrow_1_1_array_statistics_1a32b5572f78bffc37b5d325de72f2932d) of the [max](#structarrow_1_1_array_statistics_1a098402fde57058d84acd50dc74193aca) otherwise.

*   **Equals**(const [ArrayStatistics](#_CPPv4N5arrow15ArrayStatisticsE) &other, const EqualOptions &equal_options = EqualOptions::Defaults()) const

    Check two [arrow::ArrayStatistics](#structarrow_1_1_array_statistics) for equality.

    Parameters:

    *   **other** -- The [arrow::ArrayStatistics](#structarrow_1_1_array_statistics) instance to compare against.

    *   **equal_options** -- Options used to compare double values for equality.

    Returns:

    True if the two [arrow::ArrayStatistics](#structarrow_1_1_array_statistics) instances are equal; otherwise, false.

*   **operator==**(const [ArrayStatistics](#_CPPv4N5arrow15ArrayStatisticsE) &other) const

    Check two statistics for equality.

*   **operator!=**(const [ArrayStatistics](#_CPPv4N5arrow15ArrayStatisticsE) &other) const

    Check two statistics for not equality.

Public Members

*   `std::optional<int64_t> null_count = std::nullopt`

    The number of null values, may not be set.

*   `std::optional<int64_t> distinct_count = std::nullopt`

    The number of distinct values, may not be set.

*   `std::optional<ValueType> min = std::nullopt`

    The minimum value, may not be set.

*   `bool is_min_exact = false`

    Whether the minimum value is exact or not.

*   `std::optional<ValueType> max = std::nullopt`

    The maximum value, may not be set.

*   `bool is_max_exact = false`

    Whether the maximum value is exact or not.

### class ArrayData

Mutable container for generic Arrow array data.

This data structure is a self-contained representation of the memory and metadata inside an Arrow array data structure (called vectors in Java). The [Array](#classarrow_1_1_array) class and its concrete subclasses provide strongly-typed accessors with support for the visitor pattern and other affordances.

This class is designed for easy internal data manipulation, analytical data processing, and data transport to and from IPC messages.

This class is also useful in an analytics setting where memory may be efficiently reused. For example, computing the Abs of a numeric array should return null iff the input is null: therefore, an Abs function can reuse the validity bitmap (a [Buffer](memory.html#classarrow_1_1_buffer)) of its input as the validity bitmap of its output.

This class is meant mostly for immutable data access. Any mutable access (either to [ArrayData](#structarrow_1_1_array_data) members or to the contents of its Buffers) should take into account the fact that [ArrayData](#structarrow_1_1_array_data) instances are typically wrapped in a shared_ptr and can therefore have multiple owners at any given time. Therefore, mutable access is discouraged except when initially populating the [ArrayData](#structarrow_1_1_array_data).

Public Functions

*   `inline std::shared_ptr<[ArrayData](#_CPPv4N5arrow9ArrayDataE)> Copy() const`

    Return a shallow copy of this [ArrayData](#structarrow_1_1_array_data).

*   `[Result](support.html#_CPPv4I0EN5arrow6ResultE)<std::shared_ptr<[ArrayData](#_CPPv4N5arrow9ArrayDataE)>> CopyTo(const std::shared_ptr<[MemoryManager](memory.html#_CPPv4N5arrow13MemoryManagerE)> &to) const`

    Deep copy this [ArrayData](#structarrow_1_1_array_data) to destination memory manager.

    Returns a new [ArrayData](#structarrow_1_1_array_data) object with buffers and all child buffers copied to the destination memory manager. This includes dictionaries if applicable.

*   `[Result](support.html#_CPPv4I0EN5arrow6ResultE)<std::shared_ptr<[ArrayData](#_CPPv4N5arrow9ArrayDataE)>> ViewOrCopyTo(const std::shared_ptr<[MemoryManager](memory.html#_CPPv4N5arrow13MemoryManagerE)> &to) const`

    View or copy this [ArrayData](#structarrow_1_1_array_data) to destination memory manager.

    Tries to view the buffer contents on the given memory manager's device if possible (to avoid a copy) but falls back to copying if a no-copy view isn't supported.

*   `inline bool IsNull(int64_t i) const`

    Return the null-ness of a given array element.

    Calling `IsNull(i)` is the same as `!IsValid(i)`.

*   `inline bool IsValid(int64_t i) const`

    Return the validity of a given array element.

    For most data types, this will simply query the validity bitmap. For union and run-end-encoded arrays, the underlying child data is queried instead. For dictionary arrays, this reflects the validity of the dictionary index, but the corresponding dictionary value might still be null. For null arrays, this always returns false.

*   `template<typename T> inline const [T](#_CPPv4I0ENK5arrow9ArrayData9GetValuesEPK1Ti7int64_t) *GetValues(int i, int64_t absolute_offset) const`

    Access a buffer's data as a typed C pointer.

    If `absolute_offset` is non-zero, the type `T` must match the layout of buffer number `i` for the array's data type; otherwise offset computation would be incorrect.

    If the given buffer is bit-packed (such as a validity bitmap, or the data buffer of a boolean array), then `absolute_offset` must be zero for correct results, and any bit offset must be applied manually by the caller.

    Parameters:

    *   **i** -- the buffer index

    *   **absolute_offset** -- the offset into the buffer

*   `template<typename T> inline const [T](#_CPPv4I0ENK5arrow9ArrayData9GetValuesEPK1Ti) *GetValues(int i) const`

    Access a buffer's data as a typed C pointer.

    This method uses the array's offset to index into buffer number `i`.

    Calling this method on a bit-packed buffer (such as a validity bitmap, or the data buffer of a boolean array) will lead to incorrect results. You should instead call `GetValues(i, 0)` and apply the bit offset manually.

    Parameters:

    *   **i** -- the buffer index

*   `template<typename T> inline const [T](#_CPPv4I0ENK5arrow9ArrayData13GetValuesSafeEPK1Ti7int64_t) *GetValuesSafe(int i, int64_t absolute_offset) const`

    Access a buffer's data as a typed C pointer.

    Like `GetValues(i, absolute_offset)`, but returns nullptr if the given buffer is not a CPU buffer.

    Parameters:

    *   **i** -- the buffer index

    *   **absolute_offset** -- the offset into the buffer

*   `template<typename T> inline const [T](#_CPPv4I0ENK5arrow9ArrayData13GetValuesSafeEPK1Ti) *GetValuesSafe(int i) const`

    Access a buffer's data as a typed C pointer.

    Like `GetValues(i)`, but returns nullptr if the given buffer is not a CPU buffer.

    Parameters:

    *   **i** -- the buffer index

*   `template<typename T> inline [T](#_CPPv4I0EN5arrow9ArrayData16GetMutableValuesEP1Ti7int64_t) *GetMutableValues(int i, int64_t absolute_offset)`

    Access a buffer's data as a mutable typed C pointer.

    Like `GetValues(i, absolute_offset)`, but allows mutating buffer contents. This should only be used when initially populating the [ArrayData](#structarrow_1_1_array_data), before it is attached to a [Array](#classarrow_1_1_array) instance.

    Parameters:

    *   **i** -- the buffer index

    *   **absolute_offset** -- the offset into the buffer

*   `template<typename T> inline [T](#_CPPv4I0EN5arrow9ArrayData16GetMutableValuesEP1Ti) *GetMutableValues(int i)`

    Access a buffer's data as a mutable typed C pointer.

    Like `GetValues(i)`, but allows mutating buffer contents. This should only be used when initially populating the [ArrayData](#structarrow_1_1_array_data), before it is attached to a [Array](#classarrow_1_1_array) instance.

    Parameters:

    *   **i** -- the buffer index

*   `std::shared_ptr<[ArrayData](#_CPPv4N5arrow9ArrayDataE)> Slice(int64_t offset, int64_t length) const`

    Construct a zero-copy slice of the data with the given offset and length.

    This method applies the given slice to this [ArrayData](#structarrow_1_1_array_data), taking into account its existing offset and length. If the given `length` is too large, the slice length is clamped so as not to go past the offset end. If the given `often` is too large, or if either `offset` or `length` is negative, behavior is undefined.

    The associated [ArrayStatistics](#structarrow_1_1_array_statistics) is always discarded in a sliced [ArrayData](#structarrow_1_1_array_data), even if the slice is trivially equal to the original [ArrayData](#structarrow_1_1_array_data). If you want to reuse the statistics from the original [ArrayData](#structarrow_1_1_array_data), you must explicitly reattach them.

*   `[Result](support.html#_CPPv4I0EN5arrow6ResultE)<std::shared_ptr<[ArrayData](#_CPPv4N5arrow9ArrayDataE)>> SliceSafe(int64_t offset, int64_t length) const`

    Construct a zero-copy slice of the data with the given offset and length.

    Like `Slice(offset, length)`, but returns an error if the requested slice falls out of bounds. Unlike Slice, `length` isn't clamped to the available buffer size.

*   `inline void SetNullCount(int64_t v)`

    Set the cached physical null count.

    This should only be used when initially populating the [ArrayData](#structarrow_1_1_array_data), if it possible to compute the null count without visiting the entire validity bitmap. In most cases, relying on `GetNullCount` is sufficient.

    Parameters:

    *   **v** -- the number of nulls in the [ArrayData](#structarrow_1_1_array_data)

*   `int64_t GetNullCount() const`

    Return the physical null count.

    This method returns the number of array elements for which `IsValid` would return false.

    A cached value is returned if already available, otherwise it is first computed and stored. How it is is computed depends on the data type, see `IsValid` for details.

    Note that this method is typically much faster than calling `IsValid` for all elements. Therefore, it helps avoid per-element validity bitmap lookups in the common cases where the array contains zero or only nulls.

*   `inline bool MayHaveNulls() const`

    Return true if the array may have nulls in its validity bitmap.

    This method returns true if the data has a validity bitmap, and the physical null count is either known to be non-zero or not yet known.

    Unlike `MayHaveLogicalNulls`, this does not check for the presence of nulls in child data for data types such as unions and run-end encoded types.

    See also

    [HasValidityBitmap](#structarrow_1_1_array_data_1a12c1ec2d84ae1a52c9be8bad19c85ed1)

    See also

    [MayHaveLogicalNulls](#structarrow_1_1_array_data_1a325880d43528908f64a6e176d71aa8bc)

*   `inline bool HasValidityBitmap() const`

    Return true if the array has a validity bitmap.

*   `inline bool MayHaveLogicalNulls() const`

    Return true if the array may have logical nulls.

    Unlike `MayHaveNulls`, this method checks for null child values for types without a validity bitmap, such as unions and run-end encoded types, and for null dictionary values for dictionary types.

    This implies that `MayHaveLogicalNulls` may return true for arrays that don't have a top-level validity bitmap. It is therefore necessary to call `HasValidityBitmap` before accessing a top-level validity bitmap.

    Code that previously used MayHaveNulls and then dealt with the validity bitmap directly can be fixed to handle all types correctly without performance degradation when handling most types by adopting HasValidityBitmap and MayHaveLogicalNulls.

    Before:

        uint8_t* validity = array.MayHaveNulls() ? array.buffers[0].data : NULLPTR;
        for (int64_t i = 0; i < array.length; ++i) {
          if (validity && !bit_util::GetBit(validity, i)) {
            continue;  // skip a NULL
          }
          ...
        }

    After:

        bool all_valid = !array.MayHaveLogicalNulls();
        uint8_t* validity = array.HasValidityBitmap() ? array.buffers[0].data : NULLPTR;
        for (int64_t i = 0; i < array.length; ++i) {
          bool is_valid = all_valid ||
                          (validity && bit_util::GetBit(validity, i)) ||
                          array.IsValid(i);
          if (!is_valid) {
            continue;  // skip a NULL
          }
          ...
        }

*   `int64_t ComputeLogicalNullCount() const`

    Compute the logical null count for arrays of all types.

    If the array has a validity bitmap, this function behaves the same as GetNullCount. For arrays that have no validity bitmap but whose values may be logically null (such as union arrays and run-end encoded arrays), this function recomputes the null count every time it is called.

    See also

    [GetNullCount](#structarrow_1_1_array_data_1ae83fbd13ecbe794edf58e4b841fccf0d)

*   `DeviceAllocationType device_type() const`

    Return the device_type of the underlying buffers and children.

    If there are no buffers in this [ArrayData](#structarrow_1_1_array_data) object, it just returns DeviceAllocationType::kCPU as a default. We also assume that all buffers should be allocated on the same device type and perform DCHECKs to confirm this in debug mode.

    Returns:

    DeviceAllocationType

### class Array

[Array](#classarrow_1_1_array) base type Immutable data array with some logical type and some length.

Any memory is owned by the respective [Buffer](memory.html#classarrow_1_1_buffer) instance (or its parents).

The base class is only required to have a null bitmap buffer if the null count is greater than 0

If known, the null count can be provided in the base [Array](#classarrow_1_1_array) constructor. If the null count is not known, pass -1 to indicate that the null count is to be computed on the first call to [null_count()](#classarrow_1_1_array_1a0537d3b69a889b951e88be2fe9f3d96a)

Subclassed by [arrow::VarLengthListLikeArray< LargeListType >](#classarrow_1_1_var_length_list_like_array), [arrow::VarLengthListLikeArray< LargeListViewType >](#classarrow_1_1_var_length_list_like_array), [arrow::VarLengthListLikeArray< ListType >](#classarrow_1_1_var_length_list_like_array), [arrow::VarLengthListLikeArray< ListViewType >](#classarrow_1_1_var_length_list_like_array), [arrow::DictionaryArray](#classarrow_1_1_dictionary_array), [arrow::ExtensionArray](#classarrow_1_1_extension_array), [arrow::FixedSizeListArray](#classarrow_1_1_fixed_size_list_array), [arrow::FlatArray](#classarrow_1_1_flat_array), [arrow::RunEndEncodedArray](#classarrow_1_1_run_end_encoded_array), [arrow::StructArray](#classarrow_1_1_struct_array), [arrow::UnionArray](#classarrow_1_1_union_array), [arrow::VarLengthListLikeArray< TYPE >](#classarrow_1_1_var_length_list_like_array)

Public Functions

*   `inline bool IsNull(int64_t i) const`

    Return true if value at index is null. Does not boundscheck.

*   `inline bool IsValid(int64_t i) const`

    Return true if value at index is valid (not null).

    Does not boundscheck

*   `[Result](support.html#_CPPv4I0EN5arrow6ResultE)<std::shared_ptr<[Scalar](scalar.html#_CPPv4N5arrow6ScalarE)>> GetScalar(int64_t i) const`

    Return a [Scalar](scalar.html#structarrow_1_1_scalar) containing the value of this array at i.

*   `inline int64_t length() const`

    Size in the number of elements this array contains.

*   `inline int64_t offset() const`

    A relative position into another array's data, to enable zero-copy slicing.

    This value defaults to zero

*   `int64_t null_count() const`

    The number of null entries in the array.

    If the null count was not known at time of construction (and set to a negative value), then the null count will be computed and cached on the first invocation of this function

*   `int64_t ComputeLogicalNullCount() const`

    Computes the logical null count for arrays of all types including those that do not have a validity bitmap like union and run-end encoded arrays.

    If the array has a validity bitmap, this function behaves the same as [null_count()](#classarrow_1_1_array_1a0537d3b69a889b951e88be2fe9f3d96a). For types that have no validity bitmap, this function will recompute the null count every time it is called.

    See also

    GetNullCount

*   `inline const std::shared_ptr<[Buffer](memory.html#_CPPv4N5arrow6BufferE)> &null_bitmap() const`

    [Buffer](memory.html#classarrow_1_1_buffer) for the validity (null) bitmap, if any.

    Note that Union types never have a null bitmap.

    Note that for `null_count == 0` or for null type, this will be null. This buffer does not account for any slice offset

*   `inline const uint8_t *null_bitmap_data() const`

    Raw pointer to the null bitmap.

    Note that for `null_count == 0` or for null type, this will be null. This buffer does not account for any slice offset

*   `bool Equals(const [Array](#_CPPv4N5arrow5ArrayE) &arr, const EqualOptions& = EqualOptions::Defaults()) const`

    Equality comparison with another array.

    Note that [arrow::ArrayStatistics](#structarrow_1_1_array_statistics) is not included in the comparison.

*   `std::string Diff(const [Array](#_CPPv4N5arrow5ArrayE) &other) const`

    Return the formatted unified diff of arrow::Diff between this [Array](#classarrow_1_1_array) and another [Array](#classarrow_1_1_array).

*   `bool ApproxEquals(const std::shared_ptr<[Array](#_CPPv4N5arrow5ArrayE)> &arr, const EqualOptions& = EqualOptions::Defaults()) const`

    Approximate equality comparison with another array.

    epsilon is only used if this is FloatArray or DoubleArray

    Note that [arrow::ArrayStatistics](#structarrow_1_1_array_statistics) is not included in the comparison.

*   `bool RangeEquals(int64_t start_idx, int64_t end_idx, int64_t other_start_idx, const [Array](#_CPPv4N5arrow5ArrayE) &other, const EqualOptions& = EqualOptions::Defaults()) const`

    Compare if the range of slots specified are equal for the given array and this array.

    end_idx exclusive. This methods does not bounds check.

    Note that [arrow::ArrayStatistics](#structarrow_1_1_array_statistics) is not included in the comparison.

*   `[Status](support.html#_CPPv4N5arrow6StatusE) Accept([ArrayVisitor](#_CPPv4N5arrow12ArrayVisitorE) *visitor) const`

    Apply the [ArrayVisitor::Visit()](#classarrow_1_1_array_visitor_1a690c22d9ec35a5cc4526bcd23220d33e) method specialized to the array type.

*   `[Result](support.html#_CPPv4I0EN5arrow6ResultE)<std::shared_ptr<[Array](#_CPPv4N5arrow5ArrayE)>> View(const std::shared_ptr<[DataType](datatype.html#_CPPv4N5arrow8DataTypeE)> &type) const`

    Construct a zero-copy view of this array with the given type.

    This method checks if the types are layout-compatible. Nested types are traversed in depth-first order. Data buffers must have the same item sizes, even though the logical types may be different. An error is returned if the types are not layout-compatible.

*   `[Result](support.html#_CPPv4I0EN5arrow6ResultE)<std::shared_ptr<[Array](#_CPPv4N5arrow5ArrayE)>> CopyTo(const std::shared_ptr<[MemoryManager](memory.html#_CPPv4N5arrow13MemoryManagerE)> &to) const`

    Construct a copy of the array with all buffers on destination Memory Manager.

    This method recursively copies the array's buffers and those of its children onto the destination [MemoryManager](memory.html#classarrow_1_1_memory_manager) device and returns the new [Array](#classarrow_1_1_array).

*   `[Result](support.html#_CPPv4I0EN5arrow6ResultE)<std::shared_ptr<[Array](#_CPPv4N5arrow5ArrayE)>> ViewOrCopyTo(const std::shared_ptr<[MemoryManager](memory.html#_CPPv4N5arrow13MemoryManagerE)> &to) const`

    Construct a new array attempting to zero-copy view if possible.

    Like CopyTo this method recursively goes through all of the array's buffers and those of it's children and first attempts to create zero-copy views on the destination [MemoryManager](memory.html#classarrow_1_1_memory_manager) device. If it can't, it falls back to performing a copy. See [Buffer::ViewOrCopy](memory.html#classarrow_1_1_buffer_1a3c35b3fef1ee81d3612b8555cc7ef8a8).

*   `std::shared_ptr<[Array](#_CPPv4N5arrow5ArrayE)> Slice(int64_t offset, int64_t length) const`

    Construct a zero-copy slice of the array with the indicated offset and length.

    Parameters:

    *   **offset** -- **[in]** the position of the first element in the constructed slice

    *   **length** -- **[in]** the length of the slice. If there are not enough elements in the array, the length will be adjusted accordingly

    Returns:

    a new object wrapped in std::shared_ptr<Array>

*   `std::shared_ptr<[Array](#_CPPv4N5arrow5ArrayE)> Slice(int64_t offset) const`

    Slice from offset until end of the array.

*   `[Result](support.html#_CPPv4I0EN5arrow6ResultE)<std::shared_ptr<[Array](#_CPPv4N5arrow5ArrayE)>> SliceSafe(int64_t offset, int64_t length) const`

    Input-checking variant of [Array::Slice](#classarrow_1_1_array_1a810ced0e272567671743cdbbffc85335).

*   `[Result](support.html#_CPPv4I0EN5arrow6ResultE)<std::shared_ptr<[Array](#_CPPv4N5arrow5ArrayE)>> SliceSafe(int64_t offset) const`

    Input-checking variant of [Array::Slice](#classarrow_1_1_array_1a810ced0e272567671743cdbbffc85335).

*   `std::string ToString() const`

    Returns:

    PrettyPrint representation of array suitable for debugging

*   `[Status](support.html#_CPPv4N5arrow6StatusE) Validate() const`

    Perform cheap validation checks to determine obvious inconsistencies within the array's internal data.

    This is O(k) where k is the number of descendents.

    Returns:

    [Status](support.html#classarrow_1_1_status)

*   `[Status](support.html#_CPPv4N5arrow6StatusE) ValidateFull() const`

    Perform extensive validation checks to determine inconsistencies within the array's internal data.

    This is potentially O(k\*n) where k is the number of descendents and n is the array length.

    Returns:

    [Status](support.html#classarrow_1_1_status)

*   `inline DeviceAllocationType device_type() const`

    Return the device_type that this array's data is allocated on.

    This just delegates to calling device_type on the underlying [ArrayData](#structarrow_1_1_array_data) object which backs this [Array](#classarrow_1_1_array).

    Returns:

    DeviceAllocationType

*   `inline const std::shared_ptr<[ArrayStatistics](#_CPPv4N5arrow15ArrayStatisticsE)> &statistics() const`

    Return the statistics of this [Array](#classarrow_1_1_array).

    This just delegates to calling statistics on the underlying [ArrayData](#structarrow_1_1_array_data) object which backs this [Array](#classarrow_1_1_array).

    Returns:

    const std::shared_ptr<ArrayStatistics>&

### class FlatArray : public arrow::[Array](#_CPPv4N5arrow5ArrayE)

Base class for non-nested arrays.

Subclassed by [arrow::BaseBinaryArray< BinaryType >](#classarrow_1_1_base_binary_array), [arrow::BaseBinaryArray< LargeBinaryType >](#classarrow_1_1_base_binary_array), [arrow::BaseBinaryArray< TYPE >](#classarrow_1_1_base_binary_array), [arrow::BinaryViewArray](#classarrow_1_1_binary_view_array), [arrow::NullArray](#classarrow_1_1_null_array), [arrow::PrimitiveArray](#classarrow_1_1_primitive_array)

### class PrimitiveArray : public arrow::[FlatArray](#_CPPv4N5arrow9FlatArrayE)

Base class for arrays of fixed-size logical types.

Subclassed by [arrow::BooleanArray](#classarrow_1_1_boolean_array), [arrow::DayTimeIntervalArray](#classarrow_1_1_day_time_interval_array), [arrow::FixedSizeBinaryArray](#classarrow_1_1_fixed_size_binary_array), [arrow::MonthDayNanoIntervalArray](#classarrow_1_1_month_day_nano_interval_array), [arrow::NumericArray< TYPE >](#classarrow_1_1_numeric_array)

Public Functions

*   `inline const std::shared_ptr<[Buffer](memory.html#_CPPv4N5arrow6BufferE)> &values() const`

    Does not account for any slice offset.

## Factory functions

*   `std::shared_ptr<Array> MakeArray(const std::shared_ptr<ArrayData> &data)`

    Create a strongly-typed [Array](#classarrow_1_1_array) instance from generic [ArrayData](#structarrow_1_1_array_data).

    Parameters:

    *   **data** -- **[in]** the array contents

    Returns:

    the resulting [Array](#classarrow_1_1_array) instance

*   `Result<std::shared_ptr<Array>> MakeArrayOfNull(const std::shared_ptr<DataType> &type, int64_t length, MemoryPool *pool = default_memory_pool())`

    Create a strongly-typed [Array](#classarrow_1_1_array) instance with all elements null.

    Parameters:

    *   **type** -- **[in]** the array type

    *   **length** -- **[in]** the array length

    *   **pool** -- **[in]** the memory pool to allocate memory from

*   `Result<std::shared_ptr<Array>> MakeArrayFromScalar(const Scalar &scalar, int64_t length, MemoryPool *pool = default_memory_pool())`

    Create an [Array](#classarrow_1_1_array) instance whose slots are the given scalar.

    Parameters:

    *   **scalar** -- **[in]** the value with which to fill the array

    *   **length** -- **[in]** the array length

    *   **pool** -- **[in]** the memory pool to allocate memory from

*   `Result<std::shared_ptr<Array>> MakeEmptyArray(std::shared_ptr<DataType> type, MemoryPool *pool = default_memory_pool())`

    Create an empty [Array](#classarrow_1_1_array) of a given type.

    The output [Array](#classarrow_1_1_array) will be of the given type.

    Parameters:

    *   **type** -- **[in]** the data type of the empty [Array](#classarrow_1_1_array)

    *   **pool** -- **[in]** the memory pool to allocate memory from

    Returns:

    the resulting [Array](#classarrow_1_1_array)

## Concrete array subclasses

### Primitive and temporal

### class NullArray : public arrow::[FlatArray](#_CPPv4N5arrow9FlatArrayE)

Degenerate null type [Array](#classarrow_1_1_array).

### class BooleanArray : public arrow::[PrimitiveArray](#_CPPv4N5arrow14PrimitiveArrayE)

Concrete [Array](#classarrow_1_1_array) class for boolean data.

Public Functions

*   `int64_t false_count() const`

    Return the number of false (0) values among the valid values.

    [Result](support.html#classarrow_1_1_result) is not cached.

*   `int64_t true_count() const`

    Return the number of true (1) values among the valid values.

    [Result](support.html#classarrow_1_1_result) is not cached.

### `using DecimalArray = Decimal128Array`

### class Decimal32Array : public arrow::[FixedSizeBinaryArray](#_CPPv4N5arrow20FixedSizeBinaryArrayE)

*#include <arrow/array/array_decimal.h>*

Concrete [Array](#classarrow_1_1_array) class for 32-bit decimal data.

Public Functions

*   `explicit Decimal32Array(const std::shared_ptr<[ArrayData](#_CPPv4N5arrow9ArrayDataE)> &data)`

    Construct [Decimal32Array](#classarrow_1_1_decimal32_array) from [ArrayData](#structarrow_1_1_array_data) instance.

### class Decimal64Array : public arrow::[FixedSizeBinaryArray](#_CPPv4N5arrow20FixedSizeBinaryArrayE)

*#include <arrow/array/array_decimal.h>*

Concrete [Array](#classarrow_1_1_array) class for 64-bit decimal data.

Public Functions

*   `explicit Decimal64Array(const std::shared_ptr<[ArrayData](#_CPPv4N5arrow9ArrayDataE)> &data)`

    Construct [Decimal64Array](#classarrow_1_1_decimal64_array) from [ArrayData](#structarrow_1_1_array_data) instance.

### class Decimal128Array : public arrow::[FixedSizeBinaryArray](#_CPPv4N5arrow20FixedSizeBinaryArrayE)

*#include <arrow/array/array_decimal.h>*

Concrete [Array](#classarrow_1_1_array) class for 128-bit decimal data.

Public Functions

*   `explicit Decimal128Array(const std::shared_ptr<[ArrayData](#_CPPv4N5arrow9ArrayDataE)> &data)`

    Construct [Decimal128Array](#classarrow_1_1_decimal128_array) from [ArrayData](#structarrow_1_1_array_data) instance.

### class Decimal256Array : public arrow::[FixedSizeBinaryArray](#_CPPv4N5arrow20FixedSizeBinaryArrayE)

*#include <arrow/array/array_decimal.h>*

Concrete [Array](#classarrow_1_1_array) class for 256-bit decimal data.

Public Functions

*   `explicit Decimal256Array(const std::shared_ptr<[ArrayData](#_CPPv4N5arrow9ArrayDataE)> &data)`

    Construct [Decimal256Array](#classarrow_1_1_decimal256_array) from [ArrayData](#structarrow_1_1_array_data) instance.

### template<typename TYPE> class NumericArray : public arrow::[PrimitiveArray](#_CPPv4N5arrow14PrimitiveArrayE)

*#include <arrow/array/array_primitive.h>*

Concrete [Array](#classarrow_1_1_array) class for numeric data with a corresponding C type.

This class is templated on the corresponding [DataType](datatype.html#classarrow_1_1_data_type) subclass for the given data, for example NumericArray<Int8Type> or NumericArray<Date32Type>.

Note that convenience aliases are available for all accepted types (for example Int8Array for NumericArray<Int8Type>).

### class DayTimeIntervalArray : public arrow::[PrimitiveArray](#_CPPv4N5arrow14PrimitiveArrayE)

*#include <arrow/array/array_primitive.h>*

[Array](#classarrow_1_1_array) of Day and Millisecond values.

*DayTimeArray*

### class MonthDayNanoIntervalArray : public arrow::[PrimitiveArray](#_CPPv4N5arrow14PrimitiveArrayE)

*#include <arrow/array/array_primitive.h>*

[Array](#classarrow_1_1_array) of Month, Day and nanosecond values.

### Binary-like

### template<typename TYPE> class BaseBinaryArray : public arrow::[FlatArray](#_CPPv4N5arrow9FlatArrayE)

*#include <arrow/array/array_binary.h>*

Base class for variable-sized binary arrays, regardless of offset size and logical interpretation.

Public Functions

*   `inline const uint8_t *GetValue(int64_t i, offset_type *out_length) const`

    Return the pointer to the given elements bytes.

*   `inline std::string_view GetView(int64_t i) const`

    Get binary value as a string_view.

    Parameters:

    *   **i** -- the value index

    Returns:

    the view over the selected value

*   `inline std::string_view Value(int64_t i) const`

    Get binary value as a string_view Provided for consistency with other arrays.

    Parameters:

    *   **i** -- the value index

    Returns:

    the view over the selected value

*   `inline std::string GetString(int64_t i) const`

    Get binary value as a std::string.

    Parameters:

    *   **i** -- the value index

    Returns:

    the value copied into a std::string

*   `inline std::shared_ptr<[Buffer](memory.html#_CPPv4N5arrow6BufferE)> value_offsets() const`

    Note that this buffer does not account for any slice offset.

*   `inline std::shared_ptr<[Buffer](memory.html#_CPPv4N5arrow6BufferE)> value_data() const`

    Note that this buffer does not account for any slice offset.

*   `inline offset_type value_offset(int64_t i) const`

    Return the data buffer absolute offset of the data for the value at the passed index.

    Does not perform boundschecking

*   `inline offset_type value_length(int64_t i) const`

    Return the length of the data for the value at the passed index.

    Does not perform boundschecking

*   `inline offset_type total_values_length() const`

    Return the total length of the memory in the data buffer referenced by this array.

    If the array has been sliced then this may be less than the size of the data buffer (data_->buffers[2]).

### class BinaryArray : public arrow::[BaseBinaryArray](#_CPPv4I0EN5arrow15BaseBinaryArrayE)<[BinaryType](datatype.html#_CPPv4N5arrow10BinaryTypeE)>

*#include <arrow/array/array_binary.h>*

Concrete [Array](#classarrow_1_1_array) class for variable-size binary data.

Subclassed by [arrow::StringArray](#classarrow_1_1_string_array)

### class StringArray : public arrow::[BinaryArray](#_CPPv4N5arrow11BinaryArrayE)

*#include <arrow/array/array_binary.h>*

Concrete [Array](#classarrow_1_1_array) class for variable-size string (utf-8) data.

Public Functions

*   `[Status](support.html#_CPPv4N5arrow6StatusE) ValidateUTF8() const`

    Validate that this array contains only valid UTF8 entries.

    This check is also implied by [ValidateFull()](#classarrow_1_1_array_1a793321da66d2d1839e6c89a956e4cb07)

### class LargeBinaryArray : public arrow::[BaseBinaryArray](#_CPPv4I0EN5arrow15BaseBinaryArrayE)<[LargeBinaryType](datatype.html#_CPPv4N5arrow15LargeBinaryTypeE)>

*#include <arrow/array/array_binary.h>*

Concrete [Array](#classarrow_1_1_array) class for large variable-size binary data.

Subclassed by [arrow::LargeStringArray](#classarrow_1_1_large_string_array)

### class LargeStringArray : public arrow::[LargeBinaryArray](#_CPPv4N5arrow16LargeBinaryArrayE)

*#include <arrow/array/array_binary.h>*

Concrete [Array](#classarrow_1_1_array) class for large variable-size string (utf-8) data.

Public Functions

*   `[Status](support.html#_CPPv4N5arrow6StatusE) ValidateUTF8() const`

    Validate that this array contains only valid UTF8 entries.

    This check is also implied by [ValidateFull()](#classarrow_1_1_array_1a793321da66d2d1839e6c89a956e4cb07)

### class BinaryViewArray : public arrow::[FlatArray](#_CPPv4N5arrow9FlatArrayE)

*#include <arrow/array/array_binary.h>*

Concrete [Array](#classarrow_1_1_array) class for variable-size binary view data using the [BinaryViewType::c_type](datatype.html#unionarrow_1_1_binary_view_type_1_1c__type) struct to reference in-line or out-of-line string values.

Subclassed by [arrow::StringViewArray](#classarrow_1_1_string_view_array)

### class StringViewArray : public arrow::[BinaryViewArray](#_CPPv4N5arrow15BinaryViewArrayE)

*#include <arrow/array/array_binary.h>*

Concrete [Array](#classarrow_1_1_array) class for variable-size string view (utf-8) data using [BinaryViewType::c_type](datatype.html#unionarrow_1_1_binary_view_type_1_1c__type) to reference in-line or out-of-line string values.

Public Functions

*   `[Status](support.html#_CPPv4N5arrow6StatusE) ValidateUTF8() const`

    Validate that this array contains only valid UTF8 entries.

    This check is also implied by [ValidateFull()](#classarrow_1_1_array_1a793321da66d2d1839e6c89a956e4cb07)

### class FixedSizeBinaryArray : public arrow::[PrimitiveArray](#_CPPv4N5arrow14PrimitiveArrayE)

*#include <arrow/array/array_binary.h>*

Concrete [Array](#classarrow_1_1_array) class for fixed-size binary data.

Subclassed by [arrow::Decimal128Array](#classarrow_1_1_decimal128_array), [arrow::Decimal256Array](#classarrow_1_1_decimal256_array), [arrow::Decimal32Array](#classarrow_1_1_decimal32_array), [arrow::Decimal64Array](#classarrow_1_1_decimal64_array)

### Nested

### template<typename TYPE> class VarLengthListLikeArray : public arrow::[Array](#_CPPv4N5arrow5ArrayE)

*#include <arrow/array/array_nested.h>*

Base class for variable-sized list and list-view arrays, regardless of offset size.

Subclassed by [arrow::BaseListArray< TYPE >](#classarrow_1_1_base_list_array), [arrow::BaseListViewArray< TYPE >](#classarrow_1_1_base_list_view_array)

Public Functions

*   `inline const std::shared_ptr<[Array](#_CPPv4N5arrow5ArrayE)> &values() const`

    Return array object containing the list's values.

    Note that this buffer does not account for any slice offset or length.

*   `inline const std::shared_ptr<[Buffer](memory.html#_CPPv4N5arrow6BufferE)> &value_offsets() const`

    Note that this buffer does not account for any slice offset or length.

*   `inline const offset_type *raw_value_offsets() const`

    Return pointer to raw value offsets accounting for any slice offset.

*   `virtual offset_type value_length(int64_t i) const = 0`

    Return the size of the value at a particular index.

    Since non-empty null lists and list-views are possible, avoid calling this function when the list at slot i is null.

    Pre:

    IsValid(i)

*   `inline std::shared_ptr<[Array](#_CPPv4N5arrow5ArrayE)> value_slice(int64_t i) const`

    Pre:

    IsValid(i)

*   `inline [Result](support.html#_CPPv4I0EN5arrow6ResultE)<std::shared_ptr<[Array](#_CPPv4N5arrow5ArrayE)>> FlattenRecursively([MemoryPool](memory.html#_CPPv4N5arrow10MemoryPoolE) *memory_pool = [default_memory_pool](memory.html#_CPPv4N5arrow19default_memory_poolEv)()) const`

    Flatten all level recursively until reach a non-list type, and return a non-list type [Array](#classarrow_1_1_array).

    See also

    internal::FlattenLogicalListRecursively

### template<typename TYPE> class BaseListArray : public arrow::[VarLengthListLikeArray](#_CPPv4I0EN5arrow22VarLengthListLikeArrayE)<[TYPE](#_CPPv4I0EN5arrow13BaseListArrayE)>

*#include <arrow/array/array_nested.h>*

Public Functions

*   `inline virtual offset_type value_length(int64_t i) const final`

    Return the size of the value at a particular index.

    Since non-empty null lists are possible, avoid calling this function when the list at slot i is null.

    Pre:

    IsValid(i)

### class ListArray : public arrow::[BaseListArray](#_CPPv4I0EN5arrow13BaseListArrayE)<[ListType](datatype.html#_CPPv4N5arrow8ListTypeE)>

*#include <arrow/array/array_nested.h>*

Concrete [Array](#classarrow_1_1_array) class for list data.

Subclassed by [arrow::MapArray](#classarrow_1_1_map_array)

Public Functions

*   `[Result](support.html#_CPPv4I0EN5arrow6ResultE)<std::shared_ptr<[Array](#_CPPv4N5arrow5ArrayE)>> Flatten([MemoryPool](memory.html#_CPPv4N5arrow10MemoryPoolE) *memory_pool = [default_memory_pool](memory.html#_CPPv4N5arrow19default_memory_poolEv)()) const`

    Return an [Array](#classarrow_1_1_array) that is a concatenation of the lists in this array.

    Note that it's different from [`values()`](#classarrow_1_1_var_length_list_like_array_1a81c16973ee9d86c0b4e1d8e56d9a6101) in that it takes into consideration of this array's offsets as well as null elements backed by non-empty lists (they are skipped, thus copying may be needed).

*   `std::shared_ptr<[Array](#_CPPv4N5arrow5ArrayE)> offsets() const`

    Return list offsets as an Int32Array.

    The returned array will not have a validity bitmap, so you cannot expect to pass it to [ListArray::FromArrays()](#classarrow_1_1_list_array_1a83ec0cfd3c6c70706ab7702b52adc46d) and get back the same list array if the original one has nulls.

Public Static Functions

*   `static [Result](support.html#_CPPv4I0EN5arrow6ResultE)<std::shared_ptr<[ListArray](#_CPPv4N5arrow9ListArrayE)>> FromArrays(const [Array](#_CPPv4N5arrow5ArrayE) &offsets, const [Array](#_CPPv4N5arrow5ArrayE) &values, [MemoryPool](memory.html#_CPPv4N5arrow10MemoryPoolE) *pool = [default_memory_pool](memory.html#_CPPv4N5arrow19default_memory_poolEv)(), std::shared_ptr<[Buffer](memory.html#_CPPv4N5arrow6BufferE)> null_bitmap = NULLPTR, int64_t null_count = kUnknownNullCount)`

    Construct [ListArray](#classarrow_1_1_list_array) from array of offsets and child value array.

    This function does the bare minimum of validation of the offsets and input types, and will allocate a new offsets array if necessary (i.e. if the offsets contain any nulls). If the offsets do not have nulls, they are assumed to be well-formed.

    If a null_bitmap is not provided, the nulls will be inferred from the offsets' null bitmap. But if a null_bitmap is provided, the offsets array can't have nulls.

    And when a null_bitmap is provided, the offsets array cannot be a slice (i.e. an array with [offset()](#classarrow_1_1_array_1a1a0c6c1aa06cffd1dcb3813f0d24b2fd) > 0).

    Parameters:

    *   **offsets** -- **[in]** [Array](#classarrow_1_1_array) containing n + 1 offsets encoding length and size. Must be of int32 type

    *   **values** -- **[in]** [Array](#classarrow_1_1_array) containing list values

    *   **pool** -- **[in]** [MemoryPool](memory.html#arrow_1_1_memory_pool) in case new offsets array needs to be allocated because of null values

    *   **null_bitmap** -- **[in]** Optional validity bitmap

    *   **null_count** -- **[in]** Optional null count in null_bitmap

*   `static [Result](support.html#_CPPv4I0EN5arrow6ResultE)<std::shared_ptr<[ListArray](#_CPPv4N5arrow9ListArrayE)>> FromListView(const [ListViewArray](#_CPPv4N5arrow13ListViewArrayE) &source, [MemoryPool](memory.html#_CPPv4N5arrow10MemoryPoolE) *pool)`

    Build a [ListArray](#classarrow_1_1_list_array) from a [ListViewArray](#classarrow_1_1_list_view_array).

### class LargeListArray : public arrow::[BaseListArray](#_CPPv4I0EN5arrow13BaseListArrayE)<[LargeListType](datatype.html#_CPPv4N5arrow13LargeListTypeE)>

*#include <arrow/array/array_nested.h>*

Concrete [Array](#classarrow_1_1_array) class for large list data (with 64-bit offsets)

Public Functions

*   `[Result](support.html#_CPPv4I0EN5arrow6ResultE)<std::shared_ptr<[Array](#_CPPv4N5arrow5ArrayE)>> Flatten([MemoryPool](memory.html#_CPPv4N5arrow10MemoryPoolE) *memory_pool = [default_memory_pool](memory.html#_CPPv4N5arrow19default_memory_poolEv)()) const`

    Return an [Array](#classarrow_1_1_array) that is a concatenation of the lists in this array.

    Note that it's different from [`values()`](#classarrow_1_1_var_length_list_like_array_1a81c16973ee9d86c0b4e1d8e56d9a6101) in that it takes into consideration of this array's offsets as well as null elements backed by non-empty lists (they are skipped, thus copying may be needed).

*   `std::shared_ptr<[Array](#_CPPv4N5arrow5ArrayE)> offsets() const`

    Return list offsets as an Int64Array.

Public Static Functions

*   `static [Result](support.html#_CPPv4I0EN5arrow6ResultE)<std::shared_ptr<[LargeListArray](#_CPPv4N5arrow14LargeListArrayE)>> FromArrays(const [Array](#_CPPv4N5arrow5ArrayE) &offsets, const [Array](#_CPPv4N5arrow5ArrayE) &values, [MemoryPool](memory.html#_CPPv4N5arrow10MemoryPoolE) *pool = [default_memory_pool](memory.html#_CPPv4N5arrow19default_memory_poolEv)(), std::shared_ptr<[Buffer](memory.html#_CPPv4N5arrow6BufferE)> null_bitmap = NULLPTR, int64_t null_count = kUnknownNullCount)`

    Construct [LargeListArray](#classarrow_1_1_large_list_array) from array of offsets and child value array.

    This function does the bare minimum of validation of the offsets and input types, and will allocate a new offsets array if necessary (i.e. if the offsets contain any nulls). If the offsets do not have nulls, they are assumed to be well-formed.

    If a null_bitmap is not provided, the nulls will be inferred from the offsets' null bitmap. But if a null_bitmap is provided, the offsets array can't have nulls.

    And when a null_bitmap is provided, the offsets array cannot be a slice (i.e. an array with [offset()](#classarrow_1_1_array_1a1a0c6c1aa06cffd1dcb3813f0d24b2fd) > 0).

    Parameters:

    *   **offsets** -- **[in]** [Array](#classarrow_1_1_array) containing n + 1 offsets encoding length and size. Must be of int64 type

    *   **values** -- **[in]** [Array](#classarrow_1_1_array) containing list values

    *   **pool** -- **[in]** [MemoryPool](memory.html#arrow_1_1_memory_pool) in case new offsets array needs to be allocated because of null values

    *   **null_bitmap** -- **[in]** Optional validity bitmap

    *   **null_count** -- **[in]** Optional null count in null_bitmap

*   `static [Result](support.html#_CPPv4I0EN5arrow6ResultE)<std::shared_ptr<[LargeListArray](#_CPPv4N5arrow14LargeListArrayE)>> FromListView(const [LargeListViewArray](#_CPPv4N5arrow18LargeListViewArrayE) &source, [MemoryPool](memory.html#_CPPv4N5arrow10MemoryPoolE) *pool)`

    Build a [LargeListArray](#classarrow_1_1_large_list_array) from a [LargeListViewArray](#classarrow_1_1_large_list_view_array).

### template<typename TYPE> class BaseListViewArray : public arrow::[VarLengthListLikeArray](#_CPPv4I0EN5arrow22VarLengthListLikeArrayE)<[TYPE](#_CPPv4I0EN5arrow17BaseListViewArrayE)>

*#include <arrow/array/array_nested.h>*

Public Functions

*   `inline const std::shared_ptr<[Buffer](memory.html#_CPPv4N5arrow6BufferE)> &value_sizes() const`

    Note that this buffer does not account for any slice offset or length.

*   `inline const offset_type *raw_value_sizes() const`

    Return pointer to raw value offsets accounting for any slice offset.

*   `inline virtual offset_type value_length(int64_t i) const final`

    Return the size of the value at a particular index.

    This should not be called if the list-view at slot i is null. The returned size in those cases could be any value from 0 to the length of the child values array.

    Pre:

    IsValid(i)

### class ListViewArray : public arrow::[BaseListViewArray](#_CPPv4I0EN5arrow17BaseListViewArrayE)<[ListViewType](datatype.html#_CPPv4N5arrow12ListViewTypeE)>

*#include <arrow/array/array_nested.h>*

Concrete [Array](#classarrow_1_1_array) class for list-view data.

Public Functions

*   `[Result](support.html#_CPPv4I0EN5arrow6ResultE)<std::shared_ptr<[Array](#_CPPv4N5arrow5ArrayE)>> Flatten([MemoryPool](memory.html#_CPPv4N5arrow10MemoryPoolE) *memory_pool = [default_memory_pool](memory.html#_CPPv4N5arrow19default_memory_poolEv)()) const`

    Return an [Array](#classarrow_1_1_array) that is a concatenation of the list-views in this array.

    Note that it's different from [`values()`](#classarrow_1_1_var_length_list_like_array_1a81c16973ee9d86c0b4e1d8e56d9a6101) in that it takes into consideration this array's offsets (which can be in any order) and sizes. Nulls are skipped.

    This function invokes Concatenate() if list-views are non-contiguous. It will try to minimize the number of array slices passed to Concatenate() by maximizing the size of each slice (containing as many contiguous list-views as possible).

*   `std::shared_ptr<[Array](#_CPPv4N5arrow5ArrayE)> offsets() const`

    Return list-view offsets as an Int32Array.

    The returned array will not have a validity bitmap, so you cannot expect to pass it to [ListArray::FromArrays()](#classarrow_1_1_list_array_1a83ec0cfd3c6c70706ab7702b52adc46d) and get back the same list array if the original one has nulls.

*   `std::shared_ptr<[Array](#_CPPv4N5arrow5ArrayE)> sizes() const`

    Return list-view sizes as an Int32Array.

    The returned array will not have a validity bitmap, so you cannot expect to pass it to [ListViewArray::FromArrays()](#classarrow_1_1_list_view_array_1a2b9be0cc68f15283fb274c429624eccc) and get back the same list array if the original one has nulls.

Public Static Functions

*   `static [Result](support.html#_CPPv4I0EN5arrow6ResultE)<std::shared_ptr<[ListViewArray](#_CPPv4N5arrow13ListViewArrayE)>> FromArrays(const [Array](#_CPPv4N5arrow5ArrayE) &offsets, const [Array](#_CPPv4N5arrow5ArrayE) &sizes, const [Array](#_CPPv4N5arrow5ArrayE) &values, [MemoryPool](memory.html#_CPPv4N5arrow10MemoryPoolE) *pool = [default_memory_pool](memory.html#_CPPv4N5arrow19default_memory_poolEv)(), std::shared_ptr<[Buffer](memory.html#_CPPv4N5arrow6BufferE)> null_bitmap = NULLPTR, int64_t null_count = kUnknownNullCount)`

    Construct [ListViewArray](#classarrow_1_1_list_view_array) from array of offsets, sizes, and child value array.

    Construct a [ListViewArray](#classarrow_1_1_list_view_array) using buffers from offsets and sizes arrays that project views into the child values array.

    This function does the bare minimum of validation of the offsets/sizes and input types. The offset and length of the offsets and sizes arrays must match and that will be checked, but their contents will be assumed to be well-formed.

    If a null_bitmap is not provided, the nulls will be inferred from the offsets's null bitmap. But if a null_bitmap is provided, the offsets array can't have nulls.

    And when a null_bitmap is provided, neither the offsets or sizes array can be a slice (i.e. an array with [offset()](#classarrow_1_1_array_1a1a0c6c1aa06cffd1dcb3813f0d24b2fd) > 0).

    Parameters:

    *   **offsets** -- **[in]** An array of int32 offsets into the values array. NULL values are supported if the corresponding values in sizes is NULL or 0.

    *   **sizes** -- **[in]** An array containing the int32 sizes of every view. NULL values are taken to represent a NULL list-view in the array being created.

    *   **values** -- **[in]** [Array](#classarrow_1_1_array) containing list values

    *   **pool** -- **[in]** [MemoryPool](memory.html#arrow_1_1_memory_pool)

    *   **null_bitmap** -- **[in]** Optional validity bitmap

    *   **null_count** -- **[in]** Optional null count in null_bitmap

*   `static [Result](support.html#_CPPv4I0EN5arrow6ResultE)<std::shared_ptr<[ListViewArray](#_CPPv4N5arrow13ListViewArrayE)>> FromList(const [ListArray](#_CPPv4N5arrow9ListArrayE) &list_array, [MemoryPool](memory.html#_CPPv4N5arrow10MemoryPoolE) *pool)`

    Build a [ListViewArray](#classarrow_1_1_list_view_array) from a [ListArray](#classarrow_1_1_list_array).

### class LargeListViewArray : public arrow::[BaseListViewArray](#_CPPv4I0EN5arrow17BaseListViewArrayE)<[LargeListViewType](datatype.html#_CPPv4N5arrow17LargeListViewTypeE)>

*#include <arrow/array/array_nested.h>*

Concrete [Array](#classarrow_1_1_array) class for large list-view data (with 64-bit offsets and sizes)

Public Functions

*   `[Result](support.html#_CPPv4I0EN5arrow6ResultE)<std::shared_ptr<[Array](#_CPPv4N5arrow5ArrayE)>> Flatten([MemoryPool](memory.html#_CPPv4N5arrow10MemoryPoolE) *memory_pool = [default_memory_pool](memory.html#_CPPv4N5arrow19default_memory_poolEv)()) const`

    Return an [Array](#classarrow_1_1_array) that is a concatenation of the large list-views in this array.

    Note that it's different from [`values()`](#classarrow_1_1_var_length_list_like_array_1a81c16973ee9d86c0b4e1d8e56d9a6101) in that it takes into consideration this array's offsets (which can be in any order) and sizes. Nulls are skipped.

*   `std::shared_ptr<[Array](#_CPPv4N5arrow5ArrayE)> offsets() const`

    Return list-view offsets as an Int64Array.

    The returned array will not have a validity bitmap, so you cannot expect to pass it to [LargeListArray::FromArrays()](#classarrow_1_1_large_list_array_1ac03810bbb7d2baf87a374201d77ed788) and get back the same list array if the original one has nulls.

*   `std::shared_ptr<[Array](#_CPPv4N5arrow5ArrayE)> sizes() const`

    Return list-view sizes as an Int64Array.

    The returned array will not have a validity bitmap, so you cannot expect to pass it to [LargeListViewArray::FromArrays()](#classarrow_1_1_large_list_view_array_1af371fc585255c05d549fbad25210f836) and get back the same list array if the original one has nulls.

Public Static Functions

*   `static [Result](support.html#_CPPv4I0EN5arrow6ResultE)<std::shared_ptr<[LargeListViewArray](#_CPPv4N5arrow18LargeListViewArrayE)>> FromArrays(const [Array](#_CPPv4N5arrow5ArrayE) &offsets, const [Array](#_CPPv4N5arrow5ArrayE) &sizes, const [Array](#_CPPv4N5arrow5ArrayE) &values, [MemoryPool](memory.html#_CPPv4N5arrow10MemoryPoolE) *pool = [default_memory_pool](memory.html#_CPPv4N5arrow19default_memory_poolEv)(), std::shared_ptr<[Buffer](memory.html#_CPPv4N5arrow6BufferE)> null_bitmap = NULLPTR, int64_t null_count = kUnknownNullCount)`

    Construct [LargeListViewArray](#classarrow_1_1_large_list_view_array) from array of offsets, sizes, and child value array.

    Construct an [LargeListViewArray](#classarrow_1_1_large_list_view_array) using buffers from offsets and sizes arrays that project views into the values array.

    This function does the bare minimum of validation of the offsets/sizes and input types. The offset and length of the offsets and sizes arrays must match and that will be checked, but their contents will be assumed to be well-formed.

    If a null_bitmap is not provided, the nulls will be inferred from the offsets' or sizes' null bitmap. Only one of these two is allowed to have a null bitmap. But if a null_bitmap is provided, the offsets array and the sizes array can't have nulls.

    And when a null_bitmap is provided, neither the offsets or sizes array can be a slice (i.e. an array with [offset()](#classarrow_1_1_array_1a1a0c6c1aa06cffd1dcb3813f0d24b2fd) > 0).

    Parameters:

    *   **offsets** -- **[in]** An array of int64 offsets into the values array. NULL values are supported if the corresponding values in sizes is NULL or 0.

    *   **sizes** -- **[in]** An array containing the int64 sizes of every view. NULL values are taken to represent a NULL list-view in the array being created.

    *   **values** -- **[in]** [Array](#classarrow_1_1_array) containing list values

    *   **pool** -- **[in]** [MemoryPool](memory.html#arrow_1_1_memory_pool)

    *   **null_bitmap** -- **[in]** Optional validity bitmap

    *   **null_count** -- **[in]** Optional null count in null_bitmap

*   `static [Result](support.html#_CPPv4I0EN5arrow6ResultE)<std::shared_ptr<[LargeListViewArray](#_CPPv4N5arrow18LargeListViewArrayE)>> FromList(const [LargeListArray](#_CPPv4N5arrow14LargeListArrayE) &list_array, [MemoryPool](memory.html#_CPPv4N5arrow10MemoryPoolE) *pool)`

    Build a [LargeListViewArray](#classarrow_1_1_large_list_view_array) from a [LargeListArray](#classarrow_1_1_large_list_array).

### class MapArray : public arrow::[ListArray](#_CPPv4N5arrow9ListArrayE)

*#include <arrow/array/array_nested.h>*

Concrete [Array](#classarrow_1_1_array) class for map data.

NB: "value" in this context refers to a pair of a key and the corresponding item

Public Functions

*   `inline const std::shared_ptr<[Array](#_CPPv4N5arrow5ArrayE)> &keys() const`

    Return array object containing all map keys.

*   `inline const std::shared_ptr<[Array](#_CPPv4N5arrow5ArrayE)> &items() const`

    Return array object containing all mapped items.

Public Static Functions

*   `static [Result](support.html#_CPPv4I0EN5arrow6ResultE)<std::shared_ptr<[Array](#_CPPv4N5arrow5ArrayE)>> FromArrays(const std::shared_ptr<[Array](#_CPPv4N5arrow5ArrayE)> &offsets, const std::shared_ptr<[Array](#_CPPv4N5arrow5ArrayE)> &keys, const std::shared_ptr<[Array](#_CPPv4N5arrow5ArrayE)> &items, [MemoryPool](memory.html#_CPPv4N5arrow10MemoryPoolE) *pool = [default_memory_pool](memory.html#_CPPv4N5arrow19default_memory_poolEv)(), std::shared_ptr<[Buffer](memory.html#_CPPv4N5arrow6BufferE)> null_bitmap = NULLPTR)`

    Construct [MapArray](#classarrow_1_1_map_array) from array of offsets and child key, item arrays.

    This function does the bare minimum of validation of the offsets and input types, and will allocate a new offsets array if necessary (i.e. if the offsets contain any nulls). If the offsets do not have nulls, they are assumed to be well-formed

    Parameters:

    *   **offsets** -- **[in]** [Array](#classarrow_1_1_array) containing n + 1 offsets encoding length and size. Must be of int32 type

    *   **keys** -- **[in]** [Array](#classarrow_1_1_array) containing key values

    *   **items** -- **[in]** [Array](#classarrow_1_1_array) containing item values

    *   **pool** -- **[in]** [MemoryPool](memory.html#arrow_1_1_memory_pool) in case new offsets array needs to be

    *   **null_bitmap** -- **[in]** Optional validity bitmap allocated because of null values

*   `static [Status](support.html#_CPPv4N5arrow6StatusE) ValidateChildData(const std::vector<std::shared_ptr<[ArrayData](#_CPPv4N5arrow9ArrayDataE)>> &child_data)`

    Validate child data before constructing the actual [MapArray](#classarrow_1_1_map_array).

### class FixedSizeListArray : public arrow::[Array](#_CPPv4N5arrow5ArrayE)

*#include <arrow/array/array_nested.h>*

Concrete [Array](#classarrow_1_1_array) class for fixed size list data.

Public Functions

*   `const std::shared_ptr<[Array](#_CPPv4N5arrow5ArrayE)> &values() const`

    Return array object containing the list's values.

*   `inline int32_t value_length(int64_t i = 0) const`

    Return the fixed-size of the values.

    No matter the value of the index parameter, the result is the same. So even when the value at slot i is null, this function will return a non-zero size.

    Pre:

    IsValid(i)

*   `inline std::shared_ptr<[Array](#_CPPv4N5arrow5ArrayE)> value_slice(int64_t i) const`

    Pre:

    IsValid(i)

*   `[Result](support.html#_CPPv4I0EN5arrow6ResultE)<std::shared_ptr<[Array](#_CPPv4N5arrow5ArrayE)>> Flatten([MemoryPool](memory.html#_CPPv4N5arrow10MemoryPoolE) *memory_pool = [default_memory_pool](memory.html#_CPPv4N5arrow19default_memory_poolEv)()) const`

    Return an [Array](#classarrow_1_1_array) that is a concatenation of the lists in this array.

    Note that it's different from [`values()`](#classarrow_1_1_fixed_size_list_array_1a4a508158328a87f308a24848258e7807) in that it takes into consideration null elements (they are skipped, thus copying may be needed).

*   `inline [Result](support.html#_CPPv4I0EN5arrow6ResultE)<std::shared_ptr<[Array](#_CPPv4N5arrow5ArrayE)>> FlattenRecursively([MemoryPool](memory.html#_CPPv4N5arrow10MemoryPoolE) *memory_pool = [default_memory_pool](memory.html#_CPPv4N5arrow19default_memory_poolEv)()) const`

    Flatten all level recursively until reach a non-list type, and return a non-list type [Array](#classarrow_1_1_array).

    See also

    internal::FlattenLogicalListRecursively

Public Static Functions

*   `static [Result](support.html#_CPPv4I0EN5arrow6ResultE)<std::shared_ptr<[Array](#_CPPv4N5arrow5ArrayE)>> FromArrays(const std::shared_ptr<[Array](#_CPPv4N5arrow5ArrayE)> &values, int32_t list_size, std::shared_ptr<[Buffer](memory.html#_CPPv4N5arrow6BufferE)> null_bitmap = NULLPTR, int64_t null_count = kUnknownNullCount)`

    Construct [FixedSizeListArray](#classarrow_1_1_fixed_size_list_array) from child value array and value_length.

    Parameters:

    *   **values** -- **[in]** [Array](#classarrow_1_1_array) containing list values

    *   **list_size** -- **[in]** The fixed length of each list

    *   **null_bitmap** -- **[in]** Optional validity bitmap

    *   **null_count** -- **[in]** Optional null count in null_bitmap

    Returns:

    Will have length equal to values.length() / list_size

*   `static [Result](support.html#_CPPv4I0EN5arrow6ResultE)<std::shared_ptr<[Array](#_CPPv4N5arrow5ArrayE)>> FromArrays(const std::shared_ptr<[Array](#_CPPv4N5arrow5ArrayE)> &values, std::shared_ptr<[DataType](datatype.html#_CPPv4N5arrow8DataTypeE)> type, std::shared_ptr<[Buffer](memory.html#_CPPv4N5arrow6BufferE)> null_bitmap = NULLPTR, int64_t null_count = kUnknownNullCount)`

    Construct [FixedSizeListArray](#classarrow_1_1_fixed_size_list_array) from child value array and type.

    Parameters:

    *   **values** -- **[in]** [Array](#classarrow_1_1_array) containing list values

    *   **type** -- **[in]** The fixed sized list type

    *   **null_bitmap** -- **[in]** Optional validity bitmap

    *   **null_count** -- **[in]** Optional null count in null_bitmap

    Returns:

    Will have length equal to values.length() / type.list_size()

### class StructArray : public arrow::[Array](#_CPPv4N5arrow5ArrayE)

*#include <arrow/array/array_nested.h>*

Concrete [Array](#classarrow_1_1_array) class for struct data.

Public Functions

*   `std::shared_ptr<[Array](#_CPPv4N5arrow5ArrayE)> GetFieldByName(const std::string &name) const`

    Returns null if name not found.

*   `[Status](support.html#_CPPv4N5arrow6StatusE) CanReferenceFieldByName(const std::string &name) const`

    Indicate if field named `name` can be found unambiguously in the struct.

*   `[Status](support.html#_CPPv4N5arrow6StatusE) CanReferenceFieldsByNames(const std::vector<std::string> &names) const`

    Indicate if fields named `names` can be found unambiguously in the struct.

*   `[Result](support.html#_CPPv4I0EN5arrow6ResultE)<ArrayVector> Flatten([MemoryPool](memory.html#_CPPv4N5arrow10MemoryPoolE) *pool = [default_memory_pool](memory.html#_CPPv4N5arrow19default_memory_poolEv)()) const`

    Flatten this array as a vector of arrays, one for each field.

    Parameters:

    *   **pool** -- **[in]** The pool to allocate null bitmaps from, if necessary

*   `[Result](support.html#_CPPv4I0EN5arrow6ResultE)<std::shared_ptr<[Array](#_CPPv4N5arrow5ArrayE)>> GetFlattenedField(int index, [MemoryPool](memory.html#_CPPv4N5arrow10MemoryPoolE) *pool = [default_memory_pool](memory.html#_CPPv4N5arrow19default_memory_poolEv)()) const`

    Get one of the child arrays, combining its null bitmap with the parent struct array's bitmap.

    Parameters:

    *   **index** -- **[in]** Which child array to get

    *   **pool** -- **[in]** The pool to allocate null bitmaps from, if necessary

Public Static Functions

*   `static [Result](support.html#_CPPv4I0EN5arrow6ResultE)<std::shared_ptr<[StructArray](#_CPPv4N5arrow11StructArrayE)>> Make(const ArrayVector &children, const std::vector<std::string> &field_names, std::shared_ptr<[Buffer](memory.html#_CPPv4N5arrow6BufferE)> null_bitmap = NULLPTR, int64_t null_count = kUnknownNullCount, int64_t offset = 0)`

    Return a [StructArray](#classarrow_1_1_struct_array) from child arrays and field names.

    The length and data type are automatically inferred from the arguments. There should be at least one child array.

*   `static [Result](support.html#_CPPv4I0EN5arrow6ResultE)<std::shared_ptr<[StructArray](#_CPPv4N5arrow11StructArrayE)>> Make(const ArrayVector &children, const FieldVector &fields, std::shared_ptr<[Buffer](memory.html#_CPPv4N5arrow6BufferE)> null_bitmap = NULLPTR, int64_t null_count = kUnknownNullCount, int64_t offset = 0)`

    Return a [StructArray](#classarrow_1_1_struct_array) from child arrays and fields.

    The length is automatically inferred from the arguments. There should be at least one child array. This method does not check that field types and child array types are consistent.

### class UnionArray : public arrow::[Array](#_CPPv4N5arrow5ArrayE)

*#include <arrow/array/array_nested.h>*

Base class for [SparseUnionArray](#classarrow_1_1_sparse_union_array) and [DenseUnionArray](#classarrow_1_1_dense_union_array).

Subclassed by [arrow::DenseUnionArray](#classarrow_1_1_dense_union_array), [arrow::SparseUnionArray](#classarrow_1_1_sparse_union_array)

Public Functions

*   `inline const std::shared_ptr<[Buffer](memory.html#_CPPv4N5arrow6BufferE)> &type_codes() const`

    Note that this buffer does not account for any slice offset.

*   `inline type_code_t type_code(int64_t i) const`

    The logical type code of the value at index.

*   `inline int child_id(int64_t i) const`

    The physical child id containing value at index.

*   `std::shared_ptr<[Array](#_CPPv4N5arrow5ArrayE)> field(int pos) const`

    Return the given field as an individual array.

    For sparse unions, the returned array has its offset, length and null count adjusted.

### class SparseUnionArray : public arrow::[UnionArray](#_CPPv4N5arrow10UnionArrayE)

*#include <arrow/array/array_nested.h>*

Concrete [Array](#classarrow_1_1_array) class for sparse union data.

Public Functions

*   `[Result](support.html#_CPPv4I0EN5arrow6ResultE)<std::shared_ptr<[Array](#_CPPv4N5arrow5ArrayE)>> GetFlattenedField(int index, [MemoryPool](memory.html#_CPPv4N5arrow10MemoryPoolE) *pool = [default_memory_pool](memory.html#_CPPv4N5arrow19default_memory_poolEv)()) const`

    Get one of the child arrays, adjusting its null bitmap where the union array type code does not match.

    Parameters:

    *   **index** -- **[in]** Which child array to get (i.e. the physical index, not the type code)

    *   **pool** -- **[in]** The pool to allocate null bitmaps from, if necessary

Public Static Functions

*   `static inline [Result](support.html#_CPPv4I0EN5arrow6ResultE)<std::shared_ptr<[Array](#_CPPv4N5arrow5ArrayE)>> Make(const [Array](#_CPPv4N5arrow5ArrayE) &type_ids, ArrayVector children, std::vector<type_code_t> type_codes)`

    Construct [SparseUnionArray](#classarrow_1_1_sparse_union_array) from type_ids and children.

    This function does the bare minimum of validation of the input types.

    Parameters:

    *   **type_ids** -- **[in]** An array of logical type ids for the union type

    *   **children** -- **[in]** Vector of children Arrays containing the data for each type.

    *   **type_codes** -- **[in]** Vector of type codes.

*   `static [Result](support.html#_CPPv4I0EN5arrow6ResultE)<std::shared_ptr<[Array](#_CPPv4N5arrow5ArrayE)>> Make(const [Array](#_CPPv4N5arrow5ArrayE) &type_ids, ArrayVector children, std::vector<std::string> field_names = {}, std::vector<type_code_t> type_codes = {})`

    Construct [SparseUnionArray](#classarrow_1_1_sparse_union_array) with custom field names from type_ids and children.

    This function does the bare minimum of validation of the input types.

    Parameters:

    *   **type_ids** -- **[in]** An array of logical type ids for the union type

    *   **children** -- **[in]** Vector of children Arrays containing the data for each type.

    *   **field_names** -- **[in]** Vector of strings containing the name of each field.

    *   **type_codes** -- **[in]** Vector of type codes.

### class DenseUnionArray : public arrow::[UnionArray](#_CPPv4N5arrow10UnionArrayE)

*#include <arrow/array/array_nested.h>*

Concrete [Array](#classarrow_1_1_array) class for dense union data.

Note that union types do not have a validity bitmap

Public Functions

*   `inline const std::shared_ptr<[Buffer](memory.html#_CPPv4N5arrow6BufferE)> &value_offsets() const`

    Note that this buffer does not account for any slice offset.

Public Static Functions

*   `static inline [Result](support.html#_CPPv4I0EN5arrow6ResultE)<std::shared_ptr<[Array](#_CPPv4N5arrow5ArrayE)>> Make(const [Array](#_CPPv4N5arrow5ArrayE) &type_ids, const [Array](#_CPPv4N5arrow5ArrayE) &value_offsets, ArrayVector children, std::vector<type_code_t> type_codes)`

    Construct [DenseUnionArray](#classarrow_1_1_dense_union_array) from type_ids, value_offsets, and children.

    This function does the bare minimum of validation of the offsets and input types.

    Parameters:

    *   **type_ids** -- **[in]** An array of logical type ids for the union type

    *   **value_offsets** -- **[in]** An array of signed int32 values indicating the relative offset into the respective child array for the type in a given slot. The respective offsets for each child value array must be in order / increasing.

    *   **children** -- **[in]** Vector of children Arrays containing the data for each type.

    *   **type_codes** -- **[in]** Vector of type codes.

*   `static [Result](support.html#_CPPv4I0EN5arrow6ResultE)<std::shared_ptr<[Array](#_CPPv4N5arrow5ArrayE)>> Make(const [Array](#_CPPv4N5arrow5ArrayE) &type_ids, const [Array](#_CPPv4N5arrow5ArrayE) &value_offsets, ArrayVector children, std::vector<std::string> field_names = {}, std::vector<type_code_t> type_codes = {})`

    Construct [DenseUnionArray](#classarrow_1_1_dense_union_array) with custom field names from type_ids, value_offsets, and children.

    This function does the bare minimum of validation of the offsets and input types.

    Parameters:

    *   **type_ids** -- **[in]** An array of logical type ids for the union type

    *   **value_offsets** -- **[in]** An array of signed int32 values indicating the relative offset into the respective child array for the type in a given slot. The respective offsets for each child value array must be in order / increasing.

    *   **children** -- **[in]** Vector of children Arrays containing the data for each type.

    *   **field_names** -- **[in]** Vector of strings containing the name of each field.

    *   **type_codes** -- **[in]** Vector of type codes.

### Dictionary-encoded

### class DictionaryArray : public arrow::[Array](#_CPPv4N5arrow5ArrayE)

[Array](#classarrow_1_1_array) type for dictionary-encoded data with a data-dependent dictionary.

A dictionary array contains an array of non-negative integers (the "dictionary indices") along with a data type containing a "dictionary" corresponding to the distinct values represented in the data.

For example, the array

["foo", "bar", "foo", "bar", "foo", "bar"]

with dictionary ["bar", "foo"], would have dictionary array representation

indices: [1, 0, 1, 0, 1, 0] dictionary: ["bar", "foo"]

The indices in principle may be any integer type.

Public Functions

*   `[Result](support.html#_CPPv4I0EN5arrow6ResultE)<std::shared_ptr<[Array](#_CPPv4N5arrow5ArrayE)>> Transpose(const std::shared_ptr<[DataType](datatype.html#_CPPv4N5arrow8DataTypeE)> &type, const std::shared_ptr<[Array](#_CPPv4N5arrow5ArrayE)> &dictionary, const int32_t *transpose_map, [MemoryPool](memory.html#_CPPv4N5arrow10MemoryPoolE) *pool = [default_memory_pool](memory.html#_CPPv4N5arrow19default_memory_poolEv)()) const`

    Transpose this [DictionaryArray](#classarrow_1_1_dictionary_array).

    This method constructs a new dictionary array with the given dictionary type, transposing indices using the transpose map. The type and the transpose map are typically computed using DictionaryUnifier.

    Parameters:

    *   **type** -- **[in]** the new type object

    *   **dictionary** -- **[in]** the new dictionary

    *   **transpose_map** -- **[in]** transposition array of this array's indices into the target array's indices

    *   **pool** -- **[in]** a pool to allocate the array data from

*   `bool CanCompareIndices(const [DictionaryArray](#_CPPv4N5arrow15DictionaryArrayE) &other) const`

    Determine whether dictionary arrays may be compared without unification.

*   `const std::shared_ptr<[Array](#_CPPv4N5arrow5ArrayE)> &dictionary() const`

    Return the dictionary for this array, which is stored as a member of the [ArrayData](#structarrow_1_1_array_data) internal structure.

*   `int64_t GetValueIndex(int64_t i) const`

    Return the ith value of indices, cast to int64_t.

    Not recommended for use in performance-sensitive code. Does not validate whether the value is null or out-of-bounds.

Public Static Functions

*   `static [Result](support.html#_CPPv4I0EN5arrow6ResultE)<std::shared_ptr<[Array](#_CPPv4N5arrow5ArrayE)>> FromArrays(const std::shared_ptr<[DataType](datatype.html#_CPPv4N5arrow8DataTypeE)> &type, const std::shared_ptr<[Array](#_CPPv4N5arrow5ArrayE)> &indices, const std::shared_ptr<[Array](#_CPPv4N5arrow5ArrayE)> &dictionary)`

    Construct [DictionaryArray](#classarrow_1_1_dictionary_array) from dictionary and indices array and validate.

    This function does the validation of the indices and input type. It checks if all indices are non-negative and smaller than the size of the dictionary.

    Parameters:

    *   **type** -- **[in]** a dictionary type

    *   **dictionary** -- **[in]** the dictionary with same value type as the type object

    *   **indices** -- **[in]** an array of non-negative integers smaller than the size of the dictionary

### Extension arrays

### class ExtensionArray : public arrow::[Array](#_CPPv4N5arrow5ArrayE)

Base array class for user-defined extension types.

Subclassed by [arrow::extension::Bool8Array](extension.html#classarrow_1_1extension_1_1_bool8_array), [arrow::extension::FixedShapeTensorArray](extension.html#classarrow_1_1extension_1_1_fixed_shape_tensor_array), [arrow::extension::OpaqueArray](extension.html#classarrow_1_1extension_1_1_opaque_array), [arrow::extension::UuidArray](extension.html#classarrow_1_1extension_1_1_uuid_array)

Public Functions

*   `explicit ExtensionArray(const std::shared_ptr<[ArrayData](#_CPPv4N5arrow9ArrayDataE)> &data)`

    Construct an [ExtensionArray](#classarrow_1_1_extension_array) from an [ArrayData](#structarrow_1_1_array_data).

    The [ArrayData](#structarrow_1_1_array_data) must have the right [ExtensionType](datatype.html#classarrow_1_1_extension_type).

*   `ExtensionArray(const std::shared_ptr<[DataType](datatype.html#_CPPv4N5arrow8DataTypeE)> &type, const std::shared_ptr<[Array](#_CPPv4N5arrow5ArrayE)> &storage)`

    Construct an [ExtensionArray](#classarrow_1_1_extension_array) from a type and the underlying storage.

*   `inline const std::shared_ptr<[Array](#_CPPv4N5arrow5ArrayE)> &storage() const`

    The physical storage for the extension array.

### Run-End Encoded Array

### class RunEndEncodedArray : public arrow::[Array](#_CPPv4N5arrow5ArrayE)

[Array](#classarrow_1_1_array) type for run-end encoded data.

Public Functions

*   `RunEndEncodedArray(const std::shared_ptr<[DataType](datatype.html#_CPPv4N5arrow8DataTypeE)> &type, int64_t length, const std::shared_ptr<[Array](#_CPPv4N5arrow5ArrayE)> &run_ends, const std::shared_ptr<[Array](#_CPPv4N5arrow5ArrayE)> &values, int64_t offset = 0)`

    Construct a [RunEndEncodedArray](#classarrow_1_1_run_end_encoded_array) from all parameters.

    The length and offset parameters refer to the dimensions of the logical array which is the array we would get after expanding all the runs into repeated values. As such, length can be much greater than the length of the child run_ends and values arrays.

*   `inline const std::shared_ptr<[Array](#_CPPv4N5arrow5ArrayE)> &run_ends() const`

    Returns an array holding the logical indexes of each run-end.

    The physical offset to the array is applied.

*   `inline const std::shared_ptr<[Array](#_CPPv4N5arrow5ArrayE)> &values() const`

    Returns an array holding the values of each run.

    The physical offset to the array is applied.

*   `[Result](support.html#_CPPv4I0EN5arrow6ResultE)<std::shared_ptr<[Array](#_CPPv4N5arrow5ArrayE)>> LogicalRunEnds([MemoryPool](memory.html#_CPPv4N5arrow10MemoryPoolE) *pool) const`

    Returns an array holding the logical indexes of each run end.

    If a non-zero logical offset is set, this function allocates a new array and rewrites all the run end values to be relative to the logical offset and cuts the end of the array to the logical length.

*   `std::shared_ptr<[Array](#_CPPv4N5arrow5ArrayE)> LogicalValues() const`

    Returns an array holding the values of each run.

    If a non-zero logical offset is set, this function allocates a new array containing only the values within the logical range.

*   `int64_t FindPhysicalOffset() const`

    Find the physical offset of this REE array.

    This function uses binary-search, so it has a O(log N) cost.

*   `int64_t FindPhysicalLength() const`

    Find the physical length of this REE array.

    The physical length of an REE is the number of physical values (and run-ends) necessary to represent the logical range of values from offset to length.

    Avoid calling this function if the physical length can be established in some other way (e.g. when iterating over the runs sequentially until the end). This function uses binary-search, so it has a O(log N) cost.

Public Static Functions

*   `static [Result](support.html#_CPPv4I0EN5arrow6ResultE)<std::shared_ptr<[RunEndEncodedArray](#_CPPv4N5arrow18RunEndEncodedArrayE)>> Make(const std::shared_ptr<[DataType](datatype.html#_CPPv4N5arrow8DataTypeE)> &type, int64_t logical_length, const std::shared_ptr<[Array](#_CPPv4N5arrow5ArrayE)> &run_ends, const std::shared_ptr<[Array](#_CPPv4N5arrow5ArrayE)> &values, int64_t logical_offset = 0)`

    Construct a [RunEndEncodedArray](#classarrow_1_1_run_end_encoded_array) from all parameters.

    The length and offset parameters refer to the dimensions of the logical array which is the array we would get after expanding all the runs into repeated values. As such, length can be much greater than the length of the child run_ends and values arrays.

*   `static [Result](support.html#_CPPv4I0EN5arrow6ResultE)<std::shared_ptr<[RunEndEncodedArray](#_CPPv4N5arrow18RunEndEncodedArrayE)>> Make(int64_t logical_length, const std::shared_ptr<[Array](#_CPPv4N5arrow5ArrayE)> &run_ends, const std::shared_ptr<[Array](#_CPPv4N5arrow5ArrayE)> &values, int64_t logical_offset = 0)`

    Construct a [RunEndEncodedArray](#classarrow_1_1_run_end_encoded_array) from values and run ends arrays.

    The data type is automatically inferred from the arguments. The run_ends and values arrays must have the same length.

## Chunked Arrays

### class ChunkedArray

A data structure managing a list of primitive Arrow arrays logically as one large array.

Data chunking is treated throughout this project largely as an implementation detail for performance and memory use optimization. [ChunkedArray](#classarrow_1_1_chunked_array) allows [Array](#classarrow_1_1_array) objects to be collected and interpreted as a single logical array without requiring an expensive concatenation step.

In some cases, data produced by a function may exceed the capacity of an [Array](#classarrow_1_1_array) (like [BinaryArray](#classarrow_1_1_binary_array) or [StringArray](#classarrow_1_1_string_array)) and so returning multiple Arrays is the only possibility. In these cases, we recommend returning a [ChunkedArray](#classarrow_1_1_chunked_array) instead of vector of Arrays or some alternative.

When data is processed in parallel, it may not be practical or possible to create large contiguous memory allocations and write output into them. With some data types, like binary and string types, it is not possible at all to produce non-chunked array outputs without requiring a concatenation step at the end of processing.

Application developers may tune chunk sizes based on analysis of performance profiles but many developer-users will not need to be especially concerned with the chunking details.

Preserving the chunk layout/sizes in processing steps is generally not considered to be a contract in APIs. A function may decide to alter the chunking of its result. Similarly, APIs accepting multiple [ChunkedArray](#classarrow_1_1_chunked_array) inputs should not expect the chunk layout to be the same in each input.

Public Functions

*   `inline explicit ChunkedArray(std::shared_ptr<[Array](#_CPPv4N5arrow5ArrayE)> chunk)`

    Construct a chunked array from a single [Array](#classarrow_1_1_array).

*   `explicit ChunkedArray(ArrayVector chunks, std::shared_ptr<[DataType](datatype.html#_CPPv4N5arrow8DataTypeE)> type = NULLPTR)`

    Construct a chunked array from a vector of arrays and an optional data type.

    The vector elements must have the same data type. If the data type is passed explicitly, the vector may be empty. If the data type is omitted, the vector must be non-empty.

*   `inline int64_t length() const`

    Returns:

    the total length of the chunked array; computed on construction

*   `inline int64_t null_count() const`

    Returns:

    the total number of nulls among all chunks

*   `inline int num_chunks() const`

    Returns:

    the total number of chunks in the chunked array

*   `inline const std::shared_ptr<[Array](#_CPPv4N5arrow5ArrayE)> &chunk(int i) const`

    Returns:

    chunk a particular chunk from the chunked array

*   `inline const ArrayVector &chunks() const`

    Returns:

    an ArrayVector of chunks

*   `DeviceAllocationTypeSet device_types() const`

    Returns:

    The set of device allocation types used by the chunks in this chunked array.

*   `inline bool is_cpu() const`

    Returns:

    true if all chunks are allocated on CPU-accessible memory.

*   `std::shared_ptr<[ChunkedArray](#_CPPv4N5arrow12ChunkedArrayE)> Slice(int64_t offset, int64_t length) const`

    Construct a zero-copy slice of the chunked array with the indicated offset and length.

    Parameters:

    *   **offset** -- **[in]** the position of the first element in the constructed slice

    *   **length** -- **[in]** the length of the slice. If there are not enough elements in the chunked array, the length will be adjusted accordingly

    Returns:

    a new object wrapped in std::shared_ptr<ChunkedArray>

*   `std::shared_ptr<[ChunkedArray](#_CPPv4N5arrow12ChunkedArrayE)> Slice(int64_t offset) const`

    Slice from offset until end of the chunked array.

*   `[Result](support.html#_CPPv4I0EN5arrow6ResultE)<std::vector<std::shared_ptr<[ChunkedArray](#_CPPv4N5arrow12ChunkedArrayE)>>> Flatten([MemoryPool](memory.html#_CPPv4N5arrow10MemoryPoolE) *pool = [default_memory_pool](memory.html#_CPPv4N5arrow19default_memory_poolEv)()) const`

    Flatten this chunked array as a vector of chunked arrays, one for each struct field.

    Parameters:

    *   **pool** -- **[in]** The pool for buffer allocations, if any

*   `[Result](support.html#_CPPv4I0EN5arrow6ResultE)<std::shared_ptr<[ChunkedArray](#_CPPv4N5arrow12ChunkedArrayE)>> View(const std::shared_ptr<[DataType](datatype.html#_CPPv4N5arrow8DataTypeE)> &type) const`

    Construct a zero-copy view of this chunked array with the given type.

    Calls [Array::View](#classarrow_1_1_array_1aae6abc1f1b2357b810e313289e720d19) on each constituent chunk. Always succeeds if there are zero chunks

*   `inline const std::shared_ptr<[DataType](datatype.html#_CPPv4N5arrow8DataTypeE)> &type() const`

    Return the type of the chunked array.

*   `[Result](support.html#_CPPv4I0EN5arrow6ResultE)<std::shared_ptr<[Scalar](scalar.html#_CPPv4N5arrow6ScalarE)>> GetScalar(int64_t index) const`

    Return a [Scalar](scalar.html#structarrow_1_1_scalar) containing the value of this array at index.

*   `bool Equals(const [ChunkedArray](#_CPPv4N5arrow12ChunkedArrayE) &other, const EqualOptions &opts = EqualOptions::Defaults()) const`

    Determine if two chunked arrays are equal.

    Two chunked arrays can be equal only if they have equal datatypes. However, they may be equal even if they have different chunkings.

*   `bool Equals(const std::shared_ptr<[ChunkedArray](#_CPPv4N5arrow12ChunkedArrayE)> &other, const EqualOptions &opts = EqualOptions::Defaults()) const`

    Determine if two chunked arrays are equal.

*   `bool ApproxEquals(const [ChunkedArray](#_CPPv4N5arrow12ChunkedArrayE) &other, const EqualOptions& = EqualOptions::Defaults()) const`

    Determine if two chunked arrays approximately equal.

*   `std::string ToString() const`

    Returns:

    PrettyPrint representation suitable for debugging

*   `[Status](support.html#_CPPv4N5arrow6StatusE) Validate() const`

    Perform cheap validation checks to determine obvious inconsistencies within the chunk array's internal data.

    This is O(k\*m) where k is the number of array descendents, and m is the number of chunks.

    Returns:

    [Status](support.html#classarrow_1_1_status)

*   `[Status](support.html#_CPPv4N5arrow6StatusE) ValidateFull() const`

    Perform extensive validation checks to determine inconsistencies within the chunk array's internal data.

    This is O(k\*n) where k is the number of array descendents, and n is the length in elements.

    Returns:

    [Status](support.html#classarrow_1_1_status)

Public Static Functions

*   `static [Result](support.html#_CPPv4I0EN5arrow6ResultE)<std::shared_ptr<[ChunkedArray](#_CPPv4N5arrow12ChunkedArrayE)>> MakeEmpty(std::shared_ptr<[DataType](datatype.html#_CPPv4N5arrow8DataTypeE)> type, [MemoryPool](memory.html#_CPPv4N5arrow10MemoryPoolE) *pool = [default_memory_pool](memory.html#_CPPv4N5arrow19default_memory_poolEv)())`

    Create an empty [ChunkedArray](#classarrow_1_1_chunked_array) of a given type.

    The output [ChunkedArray](#classarrow_1_1_chunked_array) will have one chunk with an empty array of the given type.

    Parameters:

    *   **type** -- **[in]** the data type of the empty [ChunkedArray](#classarrow_1_1_chunked_array)

    *   **pool** -- **[in]** the memory pool to allocate memory from

    Returns:

    the resulting [ChunkedArray](#classarrow_1_1_chunked_array)

### `using arrow::ChunkLocation = [TypedChunkLocation](#_CPPv4I0EN5arrow18TypedChunkLocationE)<int64_t>`

### template<typename IndexType> struct TypedChunkLocation

Public Members

*   `[IndexType](#_CPPv4I0EN5arrow18TypedChunkLocationE) chunk_index = 0`

    Index of the chunk in the array of chunks.

    The value is always in the range `[0, chunks.size()]`. `chunks.size()` is used to represent out-of-bounds locations.

*   `[IndexType](#_CPPv4I0EN5arrow18TypedChunkLocationE) index_in_chunk = 0`

    Index of the value in the chunk.

    The value is UNDEFINED if `chunk_index >= chunks.size()`

### class ChunkResolver

An utility that incrementally resolves logical indices into physical indices in a chunked array.

Public Functions

*   `inline explicit ChunkResolver(std::vector<int64_t> offsets) noexcept`

    Construct a [ChunkResolver](#classarrow_1_1_chunk_resolver) from a vector of chunks.size() + 1 offsets.

    The first offset must be 0 and the last offset must be the logical length of the chunked array. Each offset before the last represents the starting logical index of the corresponding chunk.

*   `inline [ChunkLocation](#_CPPv4N5arrow13ChunkLocationE) Resolve(int64_t index) const`

    Resolve a logical index to a ChunkLocation.

    The returned ChunkLocation contains the chunk index and the within-chunk index equivalent to the logical index.

    Parameters:

    *   **index** -- The logical index to resolve

    Pre:

    `index >= 0`

    Post:

    `location.chunk_index` in `[0, chunks.size()]`

    Returns:

    ChunkLocation with a valid chunk_index if index is within bounds, or with `chunk_index == chunks.size()` if logical index is `>= chunked_array.length()`.

*   `inline [ChunkLocation](#_CPPv4N5arrow13ChunkLocationE) ResolveWithHint(int64_t index, [ChunkLocation](#_CPPv4N5arrow13ChunkLocationE) hint) const`

    Resolve a logical index to a ChunkLocation.

    The returned ChunkLocation contains the chunk index and the within-chunk index equivalent to the logical index.

    Parameters:

    *   **index** -- The logical index to resolve

    *   **hint** -- ChunkLocation{} or the last ChunkLocation returned by this [ChunkResolver](#classarrow_1_1_chunk_resolver).

    Pre:

    `index >= 0`

    Post:

    `location.chunk_index` in `[0, chunks.size()]`

    Returns:

    ChunkLocation with a valid chunk_index if index is within bounds, or with `chunk_index == chunks.size()` if logical index is `>= chunked_array.length()`.

*   `template<typename IndexType> inline bool ResolveMany(int64_t n_indices, const [IndexType](#_CPPv4I0ENK5arrow13ChunkResolver11ResolveManyEb7int64_tPK9IndexTypeP18TypedChunkLocationI9IndexTypeE9IndexType) *logical_index_vec, [TypedChunkLocation](#_CPPv4I0EN5arrow18TypedChunkLocationE)<[IndexType](#_CPPv4I0ENK5arrow13ChunkResolver11ResolveManyEb7int64_tPK9IndexTypeP18TypedChunkLocationI9IndexTypeE9IndexType)> *out_chunk_location_vec, [IndexType](#_CPPv4I0ENK5arrow13ChunkResolver11ResolveManyEb7int64_tPK9IndexTypeP18TypedChunkLocationI9IndexTypeE9IndexType) chunk_hint = 0) const`

    Resolve `n_indices` logical indices to chunk indices.

    Parameters:

    *   **n_indices** -- The number of logical indices to resolve

    *   **logical_index_vec** -- The logical indices to resolve

    *   **out_chunk_location_vec** -- The output array where the locations will be written

    *   **chunk_hint** -- 0 or the last chunk_index produced by ResolveMany

    Pre:

    `0 <= logical_index_vec[i] < logical_array_length()` (for well-defined and valid chunk index results)

    Pre:

    `out_chunk_location_vec` has space for `n_indices` locations

    Pre:

    `chunk_hint` in `[0, chunks.size()]`

    Post:

    `out_chunk_location_vec[i].chunk_index` in `[0, chunks.size()]` for i in `[0, n)`

    Post:

    if `logical_index_vec[i] >= chunked_array.length()`, then `out_chunk_location_vec[i].chunk_index == chunks.size()` and `out_chunk_location_vec[i].index_in_chunk` is UNDEFINED (can be out-of-bounds)

    Post:

    if `logical_index_vec[i] < 0`, then both values in `out_chunk_index_vec[i]` are UNDEFINED

    Returns:

    false iff `chunks.size() > std::numeric_limits<IndexType>::max()`

Public Static Functions

*   `static inline int32_t Bisect(int64_t index, const int64_t *offsets, int32_t lo, int32_t hi)`

    Find the index of the chunk that contains the logical index.

    Any non-negative index is accepted. When `hi=num_offsets`, the largest possible return value is `num_offsets-1` which is equal to `chunks.size()`. Which is returned when the logical index is greater or equal the logical length of the chunked array.

    Pre:

    `index >= 0` (otherwise, when index is negative, hi-1 is returned)

    Pre:

    `lo < hi`

    Pre:

    `lo >= 0 && hi <= offsets_.size()`

## Utilities

### FromJSONString Helpers

group array-from-json-string

These helpers are intended to be used in examples, tests, or for quick prototyping and are not intended to be used where performance matters.

See the [User Guide](../arrays.html#fromjsonstring-helpers) for more information.

Functions

*   `Result<std::shared_ptr<Array>> ArrayFromJSONString(const std::shared_ptr<DataType>&, const std::string &json)`

    Create an [Array](#classarrow_1_1_array) from a JSON string.

        Result<std::shared_ptr<Array>> maybe_array =
            ArrayFromJSONString(int64(), "[2, 3, null, 7, 11]");

*   `Result<std::shared_ptr<Array>> ArrayFromJSONString(const std::shared_ptr<DataType>&, std::string_view json)`

    Create an [Array](#classarrow_1_1_array) from a JSON string.

        Result<std::shared_ptr<Array>> maybe_array =
            ArrayFromJSONString(int64(), "[2, 3, null, 7, 11]");

*   `Result<std::shared_ptr<Array>> ArrayFromJSONString(const std::shared_ptr<DataType>&, const char *json)`

    Create an [Array](#classarrow_1_1_array) from a JSON string.

        Result<std::shared_ptr<Array>> maybe_array =
            ArrayFromJSONString(int64(), "[2, 3, null, 7, 11]");

*   `Result<std::shared_ptr<ChunkedArray>> ChunkedArrayFromJSONString(const std::shared_ptr<DataType> &type, const std::vector<std::string> &json_strings)`

    Create a [ChunkedArray](#classarrow_1_1_chunked_array) from a JSON string.

        Result<std::shared_ptr<ChunkedArray>> maybe_chunked_array =
            ChunkedArrayFromJSONString(int64(), {R"([5, 10])", R"([null])", R"([16])"});

*   `Result<std::shared_ptr<Array>> DictArrayFromJSONString(const std::shared_ptr<DataType>&, std::string_view indices_json, std::string_view dictionary_json)`

    Create a [DictionaryArray](#classarrow_1_1_dictionary_array) from a JSON string.

        Result<std::shared_ptr<Array>> maybe_dict_array =
            DictArrayFromJSONString(dictionary(int32(), utf8()), "[0, 1, 0, 2, 0, 3]",
            R"(["k1", "k2", "k3", "k4"])");

*   `Result<std::shared_ptr<Scalar>> ScalarFromJSONString(const std::shared_ptr<DataType>&, std::string_view json)`

    Create a [Scalar](scalar.html#structarrow_1_1_scalar) from a JSON string.

        Result<std::shared_ptr<Scalar>> maybe_scalar =
            ScalarFromJSONString(float64(), "42", &scalar);

*   `Result<std::shared_ptr<Scalar>> DictScalarFromJSONString(const std::shared_ptr<DataType>&, std::string_view index_json, std::string_view dictionary_json)`

    Create a [DictionaryScalar](scalar.html#structarrow_1_1_dictionary_scalar) from a JSON string.

        Result<std::shared_ptr<Scalar>> maybe_dict_scalar =
            DictScalarFromJSONString(dictionary(int32(), utf8()), "3", R"(["k1", "k2", "k3",
            "k4"])", &scalar);
