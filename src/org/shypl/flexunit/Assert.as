package org.shypl.flexunit {
	import flash.utils.getQualifiedClassName;

	import org.flexunit.Assert;
	import org.hamcrest.Matcher;

	public final class Assert {

		public static function assertTrue(condition:Boolean):void {
			increaseAssertCount();
			if (!condition) {
				fail("true", "false");
			}
		}

		public static function assertFalse(condition:Boolean):void {
			increaseAssertCount();
			if (condition) {
				fail("false", "true");
			}
		}

		public static function assertNull(object:Object):void {
			increaseAssertCount();
			if (object !== null) {
				fail("null", formatClassAndValue(object));
			}
		}

		public static function assertNotNull(object:Object):void {
			increaseAssertCount();
			if (object === null) {
				fail("not null", formatClassAndValue(object));
			}
		}

		public static function assertStrictEquals(expected:Object, actual:Object):void {
			increaseAssertCount();
			if (expected !== actual) {
				formatFail(expected, actual);
			}
		}

		public static function assertStrictNotEquals(expected:Object, actual:Object):void {
			increaseAssertCount();
			if (expected === actual) {
				formatFailNot(expected, actual);
			}
		}

		public static function assertEquals(expected:Object, actual:Object):void {
			increaseAssertCount();
			if (!isEquals(expected, actual)) {
				formatFail(expected, actual);
			}
		}

		public static function assertNotEquals(expected:Object, actual:Object):void {
			increaseAssertCount();
			if (isEquals(expected, actual)) {
				formatFailNot(expected, actual);
			}
		}

		public static function assertArrayEquals(expected:Object, actual:Object):void {
			increaseAssertCount();
			if (!isArrayEquals(expected, actual)) {
				formatFail(expected, actual);
			}
		}

		public static function assertArrayNotEquals(expected:Object, actual:Object):void {
			increaseAssertCount();
			if (isArrayEquals(expected, actual)) {
				formatFailNot(expected, actual);
			}
		}

		public static function assertThat(actual:Object, matcher:Matcher):void {
			increaseAssertCount();
			org.hamcrest.assertThat(actual, matcher);
		}

		public static function assertEqualsWithComparing(expected:Object, actual:Object, comparator:Function):void {
			increaseAssertCount();
			if (!comparator(expected, actual)) {
				formatFail(expected, actual);
			}
		}

		public static function assertNotEqualsWithComparing(expected:Object, actual:Object, comparator:Function):void {
			increaseAssertCount();
			if (comparator(expected, actual)) {
				formatFailNot(expected, actual);
			}
		}

		public static function assertArrayEqualsWithComparing(expected:Object, actual:Object, elementComparator:Function):void {
			increaseAssertCount();
			if (!isArrayEqualsWithComparing(expected, actual, elementComparator)) {
				formatFail(expected, actual);
			}
		}

		public static function assertArrayNotEqualsWithComparing(expected:Object, actual:Object, elementComparator:Function):void {
			increaseAssertCount();
			if (isArrayEqualsWithComparing(expected, actual, elementComparator)) {
				formatFailNot(expected, actual);
			}
		}

		public static function isBothNull(expected:Object, actual:Object):Boolean {
			return expected === null && actual === null;
		}

		public static function isBothNotNull(expected:Object, actual:Object):Boolean {
			return expected !== null && actual !== null;
		}

		public static function isBothClass(expected:Object, actual:Object, clazz:Class):Boolean {
			return expected is clazz && actual is clazz;
		}

		public static function isEquals(expected:Object, actual:Object):Boolean {
			if (expected == actual) {
				return true;
			}

			if (isBothNotNull(expected, actual)) {
				if (isBothClass(expected, actual, Number) && isNaN(expected as Number) && isNaN(actual as Number)) {
					return true;
				}
				if (isBothClass(expected, actual, Date) && (expected as Date).getTime() == (actual as Date).getTime()) {
					return true;
				}
			}

			return false;
		}

		public static function isArrayEquals(expected:Object, actual:Object):Boolean {
			if (expected == actual) {
				return true;
			}
			if (expected == null || actual == null) {
				return false;
			}
			if (!isArrayOrVector(expected)) {
				org.flexunit.Assert.fail("Expected object is not Array or Vector");
			}
			if (!isArrayOrVector(actual)) {
				org.flexunit.Assert.fail("Actual object is not Array or Vector");
			}

			const length:uint = expected.length;
			if (actual.length != length) {
				return false;
			}

			for (var i:uint = 0; i < length; i++) {
				if (!isEquals(expected[i], actual[i])) {
					return false;
				}
			}

			return true;
		}

		public static function isArrayEqualsWithComparing(expected:Object, actual:Object, elementComparator:Function):Boolean {
			if (expected == actual) {
				return true;
			}
			if (expected == null || actual == null) {
				return false;
			}
			if (!isArrayOrVector(expected)) {
				org.flexunit.Assert.fail("Expected object is not Array or Vector");
			}
			if (!isArrayOrVector(actual)) {
				org.flexunit.Assert.fail("Actual object is not Array or Vector");
			}

			const length:uint = expected.length;
			if (actual.length != length) {
				return false;
			}

			for (var i:uint = 0; i < length; i++) {
				if (!elementComparator(expected[i], actual[i])) {
					return false;
				}
			}

			return true;
		}

		private static function increaseAssertCount():void {
			++org.flexunit.Assert._assertCount;
		}

		private static function fail(expected:String, actual:String):void {
			org.flexunit.Assert.fail("Expected " + expected + ", but was " + actual);
		}

		private static function formatFail(expected:Object, actual:Object):void {
			fail(formatClassAndValue(expected), formatClassAndValue(actual));
		}

		private static function failNot(expected:String, actual:String):void {
			org.flexunit.Assert.fail("Not expected " + expected + ", but was " + actual);
		}

		private static function formatFailNot(expected:Object, actual:Object):void {
			failNot(formatClassAndValue(expected), formatClassAndValue(actual));
		}

		private static function isArrayOrVector(object:Object):Boolean {
			return object is Array
				|| object is Vector.<*> || object is Vector.<int> || object is Vector.<uint> || object is Vector.<Number>;
		}

		private static function formatClassAndValue(value:Object):String {
			return value == null ? "<null>" : (getQualifiedClassName(value) + "<" + String(value) + ">");
		}
	}
}
