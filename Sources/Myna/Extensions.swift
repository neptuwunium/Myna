// SPDX-FileCopyrightText: 2024-2026 Neptuwunium <ada@chronovore.dev>
// SPDX-License-Identifier: EUPL-1.2

import Foundation

extension Data {
	@inlinable @inline(__always) func xor(with other: Self) -> Self {
		precondition(self.count == other.count)
		return Data(zip(self, other).map { $0 ^ $1 })
	}
}

extension Int { @inlinable @inline(__always) func align(into: Self) -> Self { (self + (into - 1)) & ~(into - 1) } }

extension InlineArray {
	@inlinable @inline(__always) static func to(data: inout Data, offset: Int = 0) {
		precondition(data.count - offset >= count)

		var value = self
		_ = withUnsafeBytes(of: &value) { ptr in
			data.withUnsafeMutableBytes({ ptr.copyBytes(to: $0, from: offset...) })
		}
	}

	var data: Data {
		var value = self
		return withUnsafeBytes(of: &value, { Data($0) })
	}
}

extension UInt8 {
	@inlinable @inline(__always) func rotate(left n: Int) -> Self { (self << n) | (self >> (8 - n)) }
	@inlinable @inline(__always) func rotate(right n: Int) -> Self { self.rotate(left: 8 - n) }
}

extension UInt16 {
	@inlinable @inline(__always) static func from(data: Data, offset: Int = 0) -> Self {
		precondition(data.count - offset >= 2)

		return Self(data[offset]) | (Self(data[offset + 1]) << 8)
	}
	@inlinable @inline(__always) static func from<let count: Int>(array: InlineArray<count, UInt8>, offset: Int = 0) -> Self {
		precondition(array.count - offset >= 2)

		return Self(array[offset]) | (Self(array[offset + 1]) << 8)
	}

	@inlinable @inline(__always) static func to(data: inout Data, offset: Int = 0) {
		precondition(data.count - offset >= 2)

		var value = self
		_ = withUnsafeBytes(of: &value) { ptr in
			data.withUnsafeMutableBytes({ ptr.copyBytes(to: $0, from: offset...) })
		}
	}

	@inlinable @inline(__always) static func to<let count: Int>(array: inout InlineArray<count, UInt8>, offset: Int = 0) {
		precondition(array.count - offset >= 2)

		var value = self
		var span = array.mutableSpan
		_ = withUnsafeBytes(of: &value) { ptr in
			span.withUnsafeMutableBytes({ ptr.copyBytes(to: $0, from: offset...) })
		}
	}

	var data: Data {
		var value = self.littleEndian
		return withUnsafeBytes(of: &value, { Data($0) })
	}

	@inlinable @inline(__always) func rotate(left n: Int) -> Self { (self << n) | (self >> (16 - n)) }
	@inlinable @inline(__always) func rotate(right n: Int) -> Self { self.rotate(left: 16 - n) }
}

extension UInt32 {
	@inlinable @inline(__always) static func from(data: Data, offset: Int = 0) -> Self {
		precondition(data.count - offset >= 4)

		// swift-format-ignore
		return Self(data[offset]) | (Self(data[offset + 1]) << 8)
			| (Self(data[offset + 2]) << 16) | (Self(data[offset + 3]) << 24)
	}

	@inlinable @inline(__always) static func from<let count: Int>(array: InlineArray<count, UInt8>, offset: Int = 0) -> Self {
		precondition(array.count - offset >= 4)

		// swift-format-ignore
		return Self(array[offset]) | (Self(array[offset + 1]) << 8)
	 		| (Self(array[offset + 2]) << 16) | (Self(array[offset + 3]) << 24)
	}

	@inlinable @inline(__always) static func to(data: inout Data, offset: Int = 0) {
		precondition(data.count - offset >= 4)

		var value = self
		_ = withUnsafeBytes(of: &value) { ptr in
			data.withUnsafeMutableBytes({ ptr.copyBytes(to: $0, from: offset...) })
		}
	}

	@inlinable @inline(__always) static func to<let count: Int>(array: inout InlineArray<count, UInt8>, offset: Int = 0) {
		precondition(array.count - offset >= 4)

		var value = self
		var span = array.mutableSpan
		_ = withUnsafeBytes(of: &value) { ptr in
			span.withUnsafeMutableBytes({ ptr.copyBytes(to: $0, from: offset...) })
		}
	}

	var data: Data {
		var value = self.littleEndian
		return withUnsafeBytes(of: &value, { Data($0) })
	}

	@inlinable @inline(__always) func rotate(left n: Int) -> Self { (self << n) | (self >> (32 - n)) }
	@inlinable @inline(__always) func rotate(right n: Int) -> Self { self.rotate(left: 32 - n) }
}

extension UInt64 {
	@inlinable @inline(__always) static func from(data: Data, offset: Int = 0) -> Self {
		precondition(data.count - offset >= 8)

		// swift-format-ignore
		return Self(data[offset]) | (Self(data[offset + 1]) << 8)
			| (Self(data[offset + 2]) << 16) | (Self(data[offset + 3]) << 24)
			| (Self(data[offset + 4]) << 32) | (Self(data[offset + 5]) << 40)
			| (Self(data[offset + 6]) << 48) | (Self(data[offset + 7]) << 56)
	}

	@inlinable @inline(__always) static func from<let count: Int>(array: InlineArray<count, UInt8>, offset: Int = 0) -> Self {
		precondition(array.count - offset >= 8)

		// swift-format-ignore
		return Self(array[offset]) | (Self(array[offset + 1]) << 8)
			| (Self(array[offset + 2]) << 16) | (Self(array[offset + 3]) << 24)
		 	| (Self(array[offset + 4]) << 32) | (Self(array[offset + 5]) << 40)
			| (Self(array[offset + 6]) << 48) | (Self(array[offset + 7]) << 56)
	}

	@inlinable @inline(__always) static func to(data: inout Data, offset: Int = 0) {
		precondition(data.count - offset >= 8)

		var value = self
		_ = withUnsafeBytes(of: &value) { ptr in
			data.withUnsafeMutableBytes({ ptr.copyBytes(to: $0, from: offset...) })
		}
	}

	@inlinable @inline(__always) static func to<let count: Int>(array: inout InlineArray<count, UInt8>, offset: Int = 0) {
		precondition(array.count - offset >= 8)

		var value = self
		var span = array.mutableSpan
		_ = withUnsafeBytes(of: &value) { ptr in
			span.withUnsafeMutableBytes({ ptr.copyBytes(to: $0, from: offset...) })
		}
	}

	var data: Data {
		var value = self.littleEndian
		return withUnsafeBytes(of: &value, { Data($0) })
	}

	@inlinable @inline(__always) func rotate(left n: Int) -> Self { (self << n) | (self >> (64 - n)) }
	@inlinable @inline(__always) func rotate(right n: Int) -> Self { self.rotate(left: 64 - n) }
}
