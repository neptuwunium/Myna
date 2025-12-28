// SPDX-FileCopyrightText: 2024-2026 Neptuwunium <ada@chronovore.dev>
// SPDX-License-Identifier: EUPL-1.2

import Foundation

extension Data {
	@inlinable @inline(__always)
	mutating func xor(inplace other: borrowing Data) {
		precondition(self.count == other.count)
		let count = self.count
		self.withUnsafeMutableBytes { selfRaw in
			other.withUnsafeBytes { otherRaw in
				let s = selfRaw.assumingMemoryBound(to: UInt8.self)
				let o = otherRaw.assumingMemoryBound(to: UInt8.self)
				for i in 0 ..< count {
					s[i] ^= o[i]
				}
			}
		}
	}
}

extension Int { @inlinable @inline(__always) func align(into: Self) -> Self { (self + (into - 1)) & ~(into - 1) } }

extension InlineArray {
	@inlinable @inline(__always) static func from(data: Data, _ fallback: Element, from relativeIndex: Data.Index = 0) -> Self {
		precondition(data.count - relativeIndex >= count)

		var value = Self(repeating: fallback)
		withUnsafeMutableBytes(of: &value) { valuePtr in
			data.withUnsafeBytes { dataPtr in
				if let baseAddress = dataPtr.baseAddress {
					let sourcePtr = UnsafeRawBufferPointer(
						start: baseAddress.advanced(by: relativeIndex),
						count: MemoryLayout<Self>.size
					)
					valuePtr.copyMemory(from: sourcePtr)
				}
			}
		}
		return value
	}

	@inlinable @inline(__always) func to(data: inout Data, from relativeIndex: Data.Index = 0) {
		precondition(data.count - relativeIndex >= count)

		var value = self
		withUnsafeBytes(of: &value) { valuePtr in
			data.withUnsafeMutableBytes { dataPtr in
				if let base = dataPtr.baseAddress {
					let dest = UnsafeMutableRawBufferPointer(
						start: base.advanced(by: relativeIndex),
						count: MemoryLayout<Self>.size
					)
					dest.copyMemory(from: valuePtr)
				}
			}
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
	@inlinable @inline(__always) static func from(data: Data, from relativeIndex: Data.Index = 0) -> Self {
		precondition(data.count - relativeIndex >= 2)

		let index = data.startIndex + relativeIndex
		return Self(data[index]) | (Self(data[index + 1]) << 8)
	}
	@inlinable @inline(__always) static func from<let count: Int>(array: InlineArray<count, UInt8>, from relativeIndex: Data.Index = 0) -> Self {
		precondition(array.count - relativeIndex >= 2)

		let index = array.startIndex + relativeIndex
		return Self(array[index]) | (Self(array[index + 1]) << 8)
	}

	@inlinable @inline(__always) func to(data: inout Data, from relativeIndex: Data.Index = 0) {
		precondition(data.count - relativeIndex >= 2)

		var value = self
		withUnsafeBytes(of: &value) { valuePtr in
			data.withUnsafeMutableBytes { dataPtr in
				if let base = dataPtr.baseAddress {
					let dest = UnsafeMutableRawBufferPointer(
						start: base.advanced(by: relativeIndex),
						count: MemoryLayout<Self>.size
					)
					dest.copyMemory(from: valuePtr)
				}
			}
		}
	}

	@inlinable @inline(__always) func to<let count: Int>(array: inout InlineArray<count, UInt8>, from relativeIndex: Data.Index = 0) {
		precondition(array.count - relativeIndex >= 2)

		var value = self
		var span = array.mutableSpan
		withUnsafeBytes(of: &value) { valuePtr in
			span.withUnsafeMutableBytes { dataPtr in
				if let base = dataPtr.baseAddress {
					let dest = UnsafeMutableRawBufferPointer(
						start: base.advanced(by: relativeIndex),
						count: MemoryLayout<Self>.size
					)
					dest.copyMemory(from: valuePtr)
				}
			}
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
	@inlinable @inline(__always) static func from(data: Data, from relativeIndex: Data.Index = 0) -> Self {
		precondition(data.count - relativeIndex >= 4)

		let index = data.startIndex + relativeIndex
		// swift-format-ignore
		return Self(data[index]) | (Self(data[index + 1]) << 8)
			| (Self(data[index + 2]) << 16) | (Self(data[index + 3]) << 24)
	}

	@inlinable @inline(__always) static func from<let count: Int>(array: InlineArray<count, UInt8>, from relativeIndex: Data.Index = 0) -> Self {
		precondition(array.count - relativeIndex >= 4)

		let index = array.startIndex + relativeIndex
		// swift-format-ignore
		return Self(array[index]) | (Self(array[index + 1]) << 8)
	 		| (Self(array[index + 2]) << 16) | (Self(array[index + 3]) << 24)
	}

	@inlinable @inline(__always) func to(data: inout Data, from relativeIndex: Data.Index = 0) {
		precondition(data.count - relativeIndex >= 4)

		var value = self
		withUnsafeBytes(of: &value) { valuePtr in
			data.withUnsafeMutableBytes { dataPtr in
				if let base = dataPtr.baseAddress {
					let dest = UnsafeMutableRawBufferPointer(
						start: base.advanced(by: relativeIndex),
						count: MemoryLayout<Self>.size
					)
					dest.copyMemory(from: valuePtr)
				}
			}
		}
	}

	@inlinable @inline(__always) func to<let count: Int>(array: inout InlineArray<count, UInt8>, from relativeIndex: Data.Index = 0) {
		precondition(array.count - relativeIndex >= 4)

		var value = self
		var span = array.mutableSpan
		withUnsafeBytes(of: &value) { valuePtr in
			span.withUnsafeMutableBytes { dataPtr in
				if let base = dataPtr.baseAddress {
					let dest = UnsafeMutableRawBufferPointer(
						start: base.advanced(by: relativeIndex),
						count: MemoryLayout<Self>.size
					)
					dest.copyMemory(from: valuePtr)
				}
			}
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
	@inlinable @inline(__always) static func from(data: Data, from relativeIndex: Data.Index = 0) -> Self {
		precondition(data.count - relativeIndex >= 8)

		let index = data.startIndex + relativeIndex
		// swift-format-ignore
		return Self(data[index]) | (Self(data[index + 1]) << 8)
			| (Self(data[index + 2]) << 16) | (Self(data[index + 3]) << 24)
			| (Self(data[index + 4]) << 32) | (Self(data[index + 5]) << 40)
			| (Self(data[index + 6]) << 48) | (Self(data[index + 7]) << 56)
	}

	@inlinable @inline(__always) static func from<let count: Int>(array: InlineArray<count, UInt8>, from relativeIndex: Data.Index = 0) -> Self {
		precondition(array.count - relativeIndex >= 8)

		let index = array.startIndex + relativeIndex
		// swift-format-ignore
		return Self(array[index]) | (Self(array[index + 1]) << 8)
			| (Self(array[index + 2]) << 16) | (Self(array[index + 3]) << 24)
		 	| (Self(array[index + 4]) << 32) | (Self(array[index + 5]) << 40)
			| (Self(array[index + 6]) << 48) | (Self(array[index + 7]) << 56)
	}

	@inlinable @inline(__always) func to(data: inout Data, from relativeIndex: Data.Index = 0) {
		precondition(data.count - relativeIndex >= 8)

		var value = self
		withUnsafeBytes(of: &value) { valuePtr in
			data.withUnsafeMutableBytes { dataPtr in
				if let base = dataPtr.baseAddress {
					let dest = UnsafeMutableRawBufferPointer(
						start: base.advanced(by: relativeIndex),
						count: MemoryLayout<Self>.size
					)
					dest.copyMemory(from: valuePtr)
				}
			}
		}
	}

	@inlinable @inline(__always) func to<let count: Int>(array: inout InlineArray<count, UInt8>, from relativeIndex: Data.Index = 0) {
		precondition(array.count - relativeIndex >= 8)

		var value = self
		var span = array.mutableSpan
		withUnsafeBytes(of: &value) { valuePtr in
			span.withUnsafeMutableBytes { dataPtr in
				if let base = dataPtr.baseAddress {
					let dest = UnsafeMutableRawBufferPointer(
						start: base.advanced(by: relativeIndex),
						count: MemoryLayout<Self>.size
					)
					dest.copyMemory(from: valuePtr)
				}
			}
		}
	}

	var data: Data {
		var value = self.littleEndian
		return withUnsafeBytes(of: &value, { Data($0) })
	}

	@inlinable @inline(__always) func rotate(left n: Int) -> Self { (self << n) | (self >> (64 - n)) }
	@inlinable @inline(__always) func rotate(right n: Int) -> Self { self.rotate(left: 64 - n) }
}
