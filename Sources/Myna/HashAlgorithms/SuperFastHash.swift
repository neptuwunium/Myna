// SPDX-FileCopyrightText: 2025-2026 Neptuwunium <ada@chronovore.dev>
// SPDX-License-Identifier: EUPL-1.2

import Foundation

public struct SuperFastHash: HashAlgorithm {
	public typealias T = UInt32

	public static let bitSize: Int = 32

	private var hash: T
	private var incomplete: InlineArray<3, UInt8>
	private var incompleteLength: Int

	public init(seed: T = 0) {
		hash = seed
		incomplete = InlineArray(repeating: 0)
		incompleteLength = 0
	}

	public mutating func update(_ data: Data) {
		guard !data.isEmpty else { return }

		let data: Data =
			switch incompleteLength {
				case 3: [incomplete[0], incomplete[1], incomplete[2]] + data
				case 2: [incomplete[0], incomplete[1]] + data
				case 1: [incomplete[0]] + data
				default: data
			}

		let length = data.count >> 2
		if data.count >= 4 {
			for index in 1 ... length {
				let off = (index - 1) << 2
				hash &+= UInt32(UInt16.from(data: data, offset: off))
				let tmp = (UInt32(UInt16.from(data: data, offset: off + 2)) << 11) ^ hash
				hash = (hash << 16) ^ tmp
				hash &+= hash >> 11
			}
		}

		incompleteLength = data.count & 3
		let offset = length << 2
		var incOff = 0

		while incompleteLength > incOff {
			incomplete[incOff] = data[offset + incOff]
			incOff += 1
		}
	}

	public mutating func finalize() -> T {
		switch incompleteLength {
			case 3:
				hash &+= UInt32(UInt16.from(array: incomplete))
				hash ^= hash << 16
				hash ^= T(Int8(bitPattern: incomplete[2])) << 18
				hash &+= hash >> 11
			case 2:
				hash &+= UInt32(UInt16.from(array: incomplete))
				hash ^= hash << 11
				hash &+= hash >> 17
			case 1:
				hash &+= T(Int8(bitPattern: incomplete[0]))
				hash ^= hash << 10
				hash &+= hash >> 1
			default: break
		}

		hash ^= hash << 3
		hash &+= hash >> 5
		hash ^= hash << 4
		hash &+= hash >> 17
		hash ^= hash << 25
		hash &+= hash >> 6

		return hash
	}

	public static func hash(_ data: Data) -> T {
		guard !data.isEmpty else { return 0 }

		var hasher = SuperFastHash()
		hasher.update(data)
		return hasher.finalize()
	}

	public static func hash(_ text: String) -> T { hash(Data(text.utf8)) }
}
