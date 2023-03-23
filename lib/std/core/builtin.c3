// Copyright (c) 2021-2022 Christoffer Lerno and contributors. All rights reserved.
// Use of this source code is governed by the MIT license
// a copy of which can be found in the LICENSE_STDLIB file.
module std::core::builtin;
import libc;
import std::hash;

fault IteratorResult
{
	NO_MORE_ELEMENT
}

fault SearchResult
{
	MISSING
}

fault VarCastResult
{
	TYPE_MISMATCH
}

/**
 * Stores a variable on the stack, then restores it at the end of the
 * macro scope.
 *
 * @param variable `the variable to store and restore`
 **/
macro void @scope(&variable; @body) @builtin
{
	var temp = variable;
	defer variable = temp;
	@body();
}

macro void @swap(&a, &b) @builtin
{
	var temp = a;
	a = b;
	b = temp;
}

/**
 * Convert a variant type to a type, returning an failure if there is a type mismatch.
 *
 * @param v `the variant to convert to the given type.`
 * @param $Type `the type to convert to`
 * @return `The variant.ptr converted to its type.`
 **/
macro varcast(variant v, $Type) @builtin
{
	if (v.type != $Type.typeid) return VarCastResult.TYPE_MISMATCH?;
	return ($Type*)v.ptr;
}

struct CallstackElement
{
	CallstackElement* prev;
	String function;
	String file;
	uint line;
}

fn void default_panic(String message, String file, String function, uint line, args...)
{
	CallstackElement* stack = $$stacktrace();
	$if ($defined(libc::stderr) && $defined(libc::fprintf))

	if (stack) stack = stack.prev;
	if (stack)
	{
		(void)io::stderr().print("\nERROR: '");
		(void)io::stderr().printf(message, ...args);
		(void)io::stderr().printn("'");
	}
	else
	{
		(void)io::stderr().print("\nERROR: '");
		(void)io::stderr().printf(message, ...args);
		(void)io::stderr().printfn("', in function %s (%s:%d)", function, file, line);
	}
	while (stack)
	{
		(void)io::stderr().printfn("  in function %s (%s:%d)", stack.function, stack.file, stack.line);
		if (stack == stack.prev) break;
		stack = stack.prev;
	}

	$endif
	$$trap();
}

typedef PanicFn = fn void(String message, String file, String function, uint line, args...);

PanicFn panic = &default_panic;

macro void unreachable($string = "Unreachable statement reached.", ...) @builtin @noreturn
{
	panic($string, $$FILE, $$FUNC, $$LINE, $vasplat());
	$$unreachable();
}

macro bitcast(expr, $Type) @builtin
{
	var $size = (usz)($sizeof(expr));
	$assert($size == $Type.sizeof, "Cannot bitcast between types of different size.");
	$Type x @noinit;
	mem::copy(&x, &expr, $size, $Type.alignof, $alignof(expr));
	return x;
}

/**
 * @require $Type.kindof == TypeKind.ENUM `Only enums may be used`
 **/
macro enum_by_name($Type, String enum_name) @builtin
{
	typeid x = $Type.typeid;
	foreach (i, name : x.names)
	{
		if (name == enum_name) return ($Type)i;
	}
	return SearchResult.MISSING?;
}

macro bool @likely(bool value, $probability = 1.0) @builtin
{
    $if ($probability == 1.0)
	return $$expect(value, true);
    $else
	return $$expect_with_probability(value, true, $probability);
    $endif
}

macro bool @unlikely(bool value, $probability = 1.0) @builtin
{
    $if ($probability == 1.0)
	return $$expect(value, false);
    $else
	return $$expect_with_probability(value, false, $probability);
    $endif
}

/**
 * @require values::@is_int(value) || values::@is_bool(value)
 * @checked $typeof(value) a = expected
 **/
macro @expect(value, expected, $probability = 1.0) @builtin
{
    $if ($probability == 1.0)
	return $$expect(value, ($typeof(value))expected);
    $else
	return $$expect_with_probability(value, expected, $probability);
    $endif
}

/**
 * Locality for prefetch, levels 0 - 3, corresponding
 * to "extremely local" to "no locality"
 **/
enum PrefetchLocality
{
	NO_LOCALITY,
	FAR,
	NEAR,
	VERY_NEAR,
}

/**
 * Prefetch a pointer.

 * @param [in] ptr `Pointer to prefetch`
 * @param $locality `Locality ranging from none to extremely local`
 * @param $write `Prefetch for write, otherwise prefetch for read.`
 **/
macro prefetch(void* ptr, PrefetchLocality $locality = VERY_NEAR, bool $write = false) @builtin
{
	$$prefetch(ptr, $write ? 1 : 0, $locality.ordinal);
}

macro swizzle(v, ...) @builtin
{
	return $$swizzle(v, $vasplat());
}

macro swizzle2(v, v2, ...) @builtin
{
	return $$swizzle2(v, v2, $vasplat());
}

macro bool @castable(#expr, $To) @builtin
{
	return $checks(($To)#expr);
}

macro bool @convertible(#expr, $To) @builtin
{
	return $checks($To x = #expr);
}

macro uint int.hash(int i) => i;
macro uint uint.hash(uint i) => i;
macro uint short.hash(short s) => s;
macro uint ushort.hash(ushort s) => s;
macro uint char.hash(char c) => c;
macro uint ichar.hash(ichar c) => c;
macro uint long.hash(long i) => (uint)((i >> 32) ^ i);
macro uint ulong.hash(ulong i) => (uint)((i >> 32) ^ i);
macro uint bool.hash(bool b) => (uint)b;
macro uint typeid.hash(typeid t) => ((ulong)(uptr)t).hash();
macro uint String.hash(String c) => (uint)fnv32a::encode(c);
macro uint char[].hash(char[] c) => (uint)fnv32a::encode(c);