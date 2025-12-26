// SPDX-FileCopyrightText: 2024-2026 Neptuwunium <ada@chronovore.dev>
// SPDX-License-Identifier: EUPL-1.2

import Foundation

/// A padding implementation that uses random noise bytes as padding.
///
/// Noise padding appends random to data to ensure it fits into a specific block size.
/// - Note: This transform cannot unpad data.
public struct NoisePadding: PaddingScheme {
	private let noise: RandomNoiseGenerator

	public init(noise: RandomNoiseGenerator? = nil) {
		self.noise = noise ?? SystemNoise()
	}

	public func unpad(data: Data) throws -> Data { data }

	public func pad(data: Data, into: Int) throws -> Data {
		var block = Data(capacity: into)
		block.append(data)

		let remain = into - data.count
		guard remain > 0 else { throw MynaError.invalidInputLength }

		block.append(try noise.getBytes(count: remain))

		return block
	}

	public var ensureExists: Bool = false
}
