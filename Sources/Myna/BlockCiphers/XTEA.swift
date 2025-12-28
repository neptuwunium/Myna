// SPDX-FileCopyrightText: 2025-2026 Neptuwunium <ada@chronovore.dev>
// SPDX-License-Identifier: EUPL-1.2

import Foundation

public struct XTEA: BlockCipher {
	public var blockSize: Int = 8

	private let key: XTEAKey
	private let rounds: Int
	private let delta: UInt32
	private let seed: UInt32

	public init(key: XTEAKey, rounds: Int = 32, delta: UInt32 = 0x9E37_79B9) {
		self.key = key
		self.rounds = rounds
		self.delta = delta
		self.seed = delta &* UInt32(rounds)
	}

	public func encrypt(_ plainText: inout Data) throws {
		guard plainText.count == 8 else {
			throw MynaError.invalidInputLength
		}

		var v0: UInt32 = UInt32.from(data: plainText)
		var v1: UInt32 = UInt32.from(data: plainText, from: 4)
		var sum: UInt32 = 0
		for _ in 1 ... rounds {
			v0 &+= (((v1 << 4) ^ (v1 >> 5)) &+ v1) ^ (sum &+ key[Int(sum & 3)])
			sum &+= delta
			v1 &+= (((v0 << 4) ^ (v0 >> 5)) &+ v0) ^ (sum &+ key[Int((sum >> 11) & 3)])
		}

		v0.to(data: &plainText)
		v1.to(data: &plainText, from: 4)
	}

	public func decrypt(_ cipherText: inout Data) throws {
		guard cipherText.count == 8 else {
			throw MynaError.invalidInputLength
		}

		var v0: UInt32 = UInt32.from(data: cipherText)
		var v1: UInt32 = UInt32.from(data: cipherText, from: 4)
		var sum = seed
		for _ in 1 ... rounds {
			v1 &-= (((v0 << 4) ^ (v0 >> 5)) &+ v0) ^ (sum &+ key[Int((sum >> 11) & 3)])
			sum &-= delta
			v0 &-= (((v1 << 4) ^ (v1 >> 5)) &+ v1) ^ (sum &+ key[Int(sum & 3)])
		}

		v0.to(data: &cipherText)
		v1.to(data: &cipherText, from: 4)
	}
}

public typealias XTEAKey = InlineArray<4, UInt32>

extension XTEAKey {
	@inlinable public static func from(data: Data, _ fallback: Element, from relativeIndex: Data.Index = 0) -> Self {
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

	@inlinable public var data: Data {
		var value = self
		return withUnsafeBytes(of: &value, { Data($0) })
	}
}
