// SPDX-FileCopyrightText: 2024-2026 Neptuwunium <ada@chronovore.dev>
// SPDX-License-Identifier: EUPL-1.2

import Foundation

extension Data { @inlinable @inline(__always) func xor(other: Self) -> Self { Data(zip(self, other).map { $0 ^ $1 }) } }

extension Int { @inlinable @inline(__always) func align(into: Self) -> Self { (self + (into - 1)) & ~(into - 1) } }

extension UInt16 {
	@inlinable @inline(__always) static func fromData(_ data: Data, offset: Int = 0) -> Self { Self(data[offset]) | (Self(data[offset + 1]) << 8) }

	var data: Data {
		var value = self.littleEndian
		return withUnsafeBytes(of: &value, { Data($0) })
	}
}

extension UInt32 {
	@inlinable @inline(__always) static func fromData(_ data: Data, offset: Int = 0) -> Self {
		Self(data[offset]) | (Self(data[offset + 1]) << 8) | (Self(data[offset + 2]) << 16) | (Self(data[offset + 3]) << 24)
	}

	var data: Data {
		var value = self.littleEndian
		return withUnsafeBytes(of: &value, { Data($0) })
	}
}

extension UInt64 {
	@inlinable @inline(__always) static func fromData(_ data: Data, offset: Int = 0) -> Self {
		Self(data[offset]) | (Self(data[offset + 1]) << 8) | (Self(data[offset + 2]) << 16) | (Self(data[offset + 3]) << 24) | (Self(data[offset + 4]) << 32) | (Self(data[offset + 5]) << 40)
			| (Self(data[offset + 6]) << 48) | (Self(data[offset + 7]) << 56)
	}

	var data: Data {
		var value = self.littleEndian
		return withUnsafeBytes(of: &value, { Data($0) })
	}
}

extension Int16 {
	@inlinable @inline(__always) static func fromData(_ data: Data, offset: Int = 0) -> Self { Self(data[offset]) | (Self(data[offset + 1]) << 8) }

	var data: Data {
		var value = self.littleEndian
		return withUnsafeBytes(of: &value, { Data($0) })
	}
}

extension Int32 {
	@inlinable @inline(__always) static func fromData(_ data: Data, offset: Int = 0) -> Self {
		Self(data[offset]) | (Self(data[offset + 1]) << 8) | (Self(data[offset + 2]) << 16) | (Self(data[offset + 3]) << 24)
	}

	var data: Data {
		var value = self.littleEndian
		return withUnsafeBytes(of: &value, { Data($0) })
	}
}

extension Int64 {
	@inlinable @inline(__always) static func fromData(_ data: Data, offset: Int = 0) -> Self {
		Self(data[offset]) | (Self(data[offset + 1]) << 8) | (Self(data[offset + 2]) << 16) | (Self(data[offset + 3]) << 24) | (Self(data[offset + 4]) << 32) | (Self(data[offset + 5]) << 40)
			| (Self(data[offset + 6]) << 48) | (Self(data[offset + 7]) << 56)
	}

	var data: Data {
		var value = self.littleEndian
		return withUnsafeBytes(of: &value, { Data($0) })
	}
}
