module std::core::string;
import std::ascii;

typedef ZString = distinct inline char*;
typedef Char32 = uint;
typedef Char16 = ushort;

fault UnicodeResult
{
	INVALID_UTF8,
	INVALID_UTF16,
	CONVERSION_FAILED,
}

const uint SURROGATE_OFFSET @private = 0x10000;
const uint SURROGATE_GENERIC_MASK @private = 0xF800;
const uint SURROGATE_MASK @private = 0xFC00;
const uint SURROGATE_CODEPOINT_MASK @private = 0x03FF;
const uint SURROGATE_BITS @private = 10;
const uint SURROGATE_LOW_VALUE @private = 0xDC00;
const uint SURROGATE_HIGH_VALUE @private = 0xD800;

fault NumberConversion
{
	EMPTY_STRING,
	NEGATIVE_VALUE,
	MALFORMED_INTEGER,
	INTEGER_OVERFLOW,
	MALFORMED_FLOAT,
	FLOAT_OUT_OF_RANGE,
}

macro String printf(String fmt, ..., Allocator* using = mem::heap())
{
	@stack_mem(256; Allocator* mem)
	{
		DString str;
		str.init(.using = mem);
		str.printf(fmt, $vasplat());
		return str.copy_str(using);
	};
}

macro String tprintf(String fmt, ...)
{
	DString str;
	str.tinit();
	str.printf(fmt, $vasplat());
	return str.str();
}

macro bool char_in_set(char c, String set)
{
	foreach (ch : set) if (ch == c) return true;
	return false;
}

fn String join(String[] s, String joiner, Allocator* using = mem::heap())
{
	if (!s)
	{
		return (String)(calloc(char, 2, .using = using)[:0]);
	}

	usz total_size = joiner.len * s.len;
	foreach (String* &str : s)
	{
		total_size += str.len;
	}
	@stack_mem(256; Allocator* mem)
	{
		DString res = dstring::new_with_capacity(total_size, .using = mem);
		res.append(s[0]);
		foreach (String* &str : s[1..])
		{
			res.append(joiner);
			res.append(*str);
		}
		return res.copy_str(using);
	};
}

/**
 * @param [in] string
 * @param [in] to_trim
 **/
fn String String.trim(String string, String to_trim = "\t\n\r ")
{
	usz start = 0;
	usz len = string.len;
	while (start < len && char_in_set(string[start], to_trim)) start++;
	if (start == len) return string[:0];
	usz end = len - 1;
	while (end > start && char_in_set(string[end], to_trim)) end--;
	return string[start..end];
}

/**
 * @param [in] string
 * @param [in] needle
 **/
fn bool String.starts_with(String string, String needle)
{
	if (needle.len > string.len) return false;
	if (!needle.len) return true;
	return string[:needle.len] == needle;
}

/**
 * @param [in] string
 * @param [in] needle
 **/
fn bool String.ends_with(String string, String needle)
{
	if (needle.len > string.len) return false;
	if (!needle.len) return true;
	return string[^needle.len..] == needle;
}

/**
 * Strip the front of the string if the prefix exists.
 *
 * @param [in] string
 * @param [in] needle
 **/
fn String String.strip(String string, String needle)
{
	if (!needle.len || !string.starts_with(needle)) return string;
	return string[needle.len..];
}

/**
 * Strip the end of the string if the suffix exists.
 *
 * @param [in] string
 * @param [in] needle
 **/
fn String String.strip_end(String string, String needle)
{
	if (!needle.len || !string.ends_with(needle)) return string;
	// Note that this is the safe way if we want to support zero length.
	return string[:(string.len - needle.len)];
}


/**
 * Split a string into parts, e.g "a|b|c" split with "|" yields { "a", "b", "c" }
 *
 * @param [in] s
 * @param [in] needle
 * @param [&inout] using "The allocator, defaults to the heap allocator"
 * @param max "Max number of elements, 0 means no limit, defaults to 0"
 * @require needle.len > 0 "The needle must be at least 1 character long"
 * @ensure return.len > 0
 **/
fn String[] String.split(String s, String needle, usz max = 0, Allocator* using = mem::heap())
{
	usz capacity = 16;
	usz i = 0;
	String* holder = malloc(String, capacity, .using = using);
	bool no_more = false;
	while (!no_more)
	{
		usz! index = i == max - 1 ? SearchResult.MISSING? : s.index_of(needle);
		String res @noinit;
		if (try index)
		{
			res = s[:index];
			s = s[index + needle.len..];
		}
		else
		{
			res = s;
			no_more = true;
		}
		if (i == capacity)
		{
			capacity *= 2;
			holder = realloc(holder, String.sizeof * capacity, .using = using);
		}
		holder[i++] = res;
	}
	return holder[:i];
}

/**
 * This function is identical to String.split, but implicitly uses the
 * temporary allocator.
 *
 * @param [in] s
 * @param [in] needle
 * @param max "Max number of elements, 0 means no limit, defaults to 0"
 **/
fn String[] String.tsplit(String s, String needle, usz max = 0)
{
	return s.split(needle, max, mem::temp()) @inline;
}

fn bool String.contains(String s, String needle)
{
	return @ok(s.index_of(needle));
}

/**
 * Find the index of the first incidence of a string.
 *
 * @param [in] s
 * @param [in] needle
 * @pure
 * @ensure return < s.len
 * @require needle.len > 0 : "The needle must be len 1 or more"
 * @return "the index of the needle"
 * @return! SearchResult.MISSING "if the needle cannot be found"
 **/
fn usz! String.index_of(String s, String needle)
{
	usz match = 0;
	usz needed = needle.len;
	usz index_start = 0;
	char search = needle[0];
	foreach (usz i, char c : s)
	{
		if (c == search)
		{
			if (!match) index_start = i;
			match++;
			if (match == needed) return index_start;
			search = needle[match];
			continue;
		}
		if (match)
		{
			match = 0;
			search = needle[0];
		}
	}
	return SearchResult.MISSING?;
}

/**
 * Find the index of the last incidence of a string.
 *
 * @param [in] s
 * @param [in] needle
 * @pure
 * @ensure return < s.len
 * @require needle.len > 0 "The needle must be len 1 or more"
 * @return "the index of the needle"
 * @return! SearchResult.MISSING "if the needle cannot be found"
 **/
fn usz! String.rindex_of(String s, String needle)
{
	usz match = 0;
	usz needed = needle.len;
	usz index_start = 0;
	char search = needle[^1];
	foreach_r (usz i, char c : s)
	{
		if (c == search)
		{
			if (!match) index_start = i;
			match++;
			if (match == needed) return index_start - needle.len + 1;
			search = needle[^(match + 1)];
			continue;
		}
		if (match)
		{
			match = 0;
			search = needle[^1];
		}
	}
	return SearchResult.MISSING?;
}

fn String ZString.as_str(ZString str)
{
	return (String)((char*)str)[:str.len()];
}

fn usz ZString.char_len(ZString str)
{
	usz len = 0;
	char* ptr = (char*)str;
	while (char c = ptr++[0])
	{
		if (c & 0xC0 != 0x80) len++;
	}
	return len;
}

fn usz ZString.len(ZString str)
{
	usz len = 0;
    char* ptr = (char*)str;
    while (char c = ptr++[0]) len++;
    return len;
}


fn ZString String.zstr_copy(String s, Allocator* using = mem::heap())
{
    usz len = s.len;
    char* str = malloc(len + 1, .using = using);
    mem::copy(str, s.ptr, len);
    str[len] = 0;
    return (ZString)str;
}

fn String String.concat(String s1, String s2, Allocator* using = mem::heap())
{
    usz full_len = s1.len + s2.len;
    char* str = malloc(full_len + 1, .using = using);
    usz s1_len = s1.len;
    mem::copy(str, s1.ptr, s1_len);
    mem::copy(str + s1_len, s2.ptr, s2.len);
    str[full_len] = 0;
    return (String)str[:full_len];
}

fn String String.tconcat(String s1, String s2) => s1.concat(s2, mem::temp());


fn ZString String.zstr_tcopy(String s) => s.zstr_copy(mem::temp()) @inline;

fn String String.copy(String s, Allocator* using = mem::heap())
{
    usz len = s.len;
    char* str = malloc(len + 1, .using = using);
    mem::copy(str, s.ptr, len);
    str[len] = 0;
    return (String)str[:len];
}

fn String String.tcopy(String s) => s.copy(mem::temp()) @inline;

fn String ZString.copy(ZString z, Allocator* using = mem::heap()) => z.as_str().copy(using) @inline;
fn String ZString.tcopy(ZString z) => z.as_str().copy(mem::temp()) @inline;

/**
 * Convert an UTF-8 string to UTF-16
 * @return "The UTF-16 string as a slice, allocated using the given allocator"
 * @return! UnicodeResult.INVALID_UTF8 "If the string contained an invalid UTF-8 sequence"
 * @return! AllocationFailure "If allocation of the string fails"
 **/
fn Char16[]! String.to_utf16(String s, Allocator* using = mem::heap())
{
	usz len16 = conv::utf16len_for_utf8(s);
	Char16* data = malloc_checked(Char16, len16 + 1, .using = using)!;
	conv::utf8to16_unsafe(s, data)!;
	data[len16] = 0;
	return data[:len16];
}

fn Char32[]! String.to_utf32(String s, Allocator* using = mem::heap())
{
	usz codepoints = conv::utf8_codepoints(s);
	Char32* data = malloc_checked(Char32, codepoints + 1, .using = using)!;
	conv::utf8to32_unsafe(s, data)!;
	data[codepoints] = 0;
	return data[:codepoints];
}

fn String! from_utf32(Char32[] utf32, Allocator* using = mem::heap())
{
	usz len = conv::utf8len_for_utf32(utf32);
	char* data = malloc_checked(len + 1, .using = using)!;
	defer catch free(data, .using = using);
	conv::utf32to8_unsafe(utf32, data);
	data[len] = 0;
	return (String)data[:len];
}

fn String! from_utf16(Char16[] utf16, Allocator* using = mem::heap())
{
	usz len = conv::utf8len_for_utf16(utf16);
	char* data = malloc_checked(len + 1, .using = using)!;
	defer catch free(data, .using = using);
	conv::utf16to8_unsafe(utf16, data)!;
	data[len] = 0;
	return (String)data[:len];
}

fn String! from_zutf16(Char16* utf16_pointer, Allocator* using = mem::heap())
{
	usz utf16_len;
	while (utf16_pointer[utf16_len] != 0) utf16_len++;
	Char16[] utf16 = utf16_pointer[:utf16_len];
	return from_utf16(utf16, using);
}

fn usz String.utf8_codepoints(String s)
{
	usz len = 0;
	foreach (char c : s)
	{
		if (c & 0xC0 != 0x80) len++;
	}
	return len;
}


macro String.to_integer(String string, $Type)
{
	usz len = string.len;
	usz index = 0;
	char* ptr = string.ptr;
	while (index < len && ascii::is_blank_m(ptr[index])) index++;
	if (len == index) return NumberConversion.EMPTY_STRING?;
	bool is_negative;
	switch (string[index])
	{
		case '-':
			if ($Type.min == 0) return NumberConversion.NEGATIVE_VALUE?;
			is_negative = true;
			index++;
		case '+':
			index++;
		default:
			break;
	}
	if (len == index) return NumberConversion.MALFORMED_INTEGER?;
	$Type base = 10;
	if (string[index] == '0')
	{
		index++;
		if (index == len) return ($Type)0;
		switch (string[index])
		{
			case 'x':
			case 'X':
				base = 16;
				index++;
			case 'b':
			case 'B':
				base = 2;
				index++;
			case 'o':
			case 'O':
				base = 8;
				index++;
			default:
				break;
		}
		if (len == index) return NumberConversion.MALFORMED_INTEGER?;
	}
	$Type value = 0;
	while (index != len)
	{
		char c = {|
			char ch = string[index++];
			if (base != 16 || ch < 'A') return (char)(ch - '0');
			if (ch <= 'F') return (char)(ch - 'A');
			if (ch < 'a') return NumberConversion.MALFORMED_INTEGER?;
			if (ch > 'f') return NumberConversion.MALFORMED_INTEGER?;
			return (char)(ch - 'a');
		|}!;
		if (c >= base) return NumberConversion.MALFORMED_INTEGER?;
		value = {|
			if (is_negative)
			{
				$Type new_value = value * base - c;
				if (new_value > value) return NumberConversion.INTEGER_OVERFLOW?;
				return new_value;
			}
			$Type new_value = value * base + c;
			if (new_value < value) return NumberConversion.INTEGER_OVERFLOW?;
			return new_value;
		|}!;
	}
	return value;
}


fn Char16[]! String.to_temp_utf16(String s) => s.to_utf16(mem::temp());

fn int128! String.to_int128(String s) => s.to_integer(int128);
fn long! String.to_long(String s) => s.to_integer(long);
fn int! String.to_int(String s) => s.to_integer(int);
fn short! String.to_short(String s) => s.to_integer(short);
fn ichar! String.to_ichar(String s) => s.to_integer(ichar);

fn uint128! String.to_uint128(String s) => s.to_integer(uint128);
fn ulong! String.to_ulong(String s) => s.to_integer(ulong);
fn uint! String.to_uint(String s) => s.to_integer(uint);
fn ushort! String.to_ushort(String s) => s.to_integer(ushort);
fn char! String.to_uchar(String s) => s.to_integer(char);

fn double! String.to_double(String s) => s.to_real(double);
fn float! String.to_float(String s) => s.to_real(float);
