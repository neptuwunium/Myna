// SPDX-FileCopyrightText: 2024-2026 Neptuwunium <ada@chronovore.dev>
// SPDX-License-Identifier: EUPL-1.2

import Algorithms
import Foundation

internal struct TransformHelper {
	private init() {}

	internal static func prepareBlocks(text: Data, _ algorithm: BlockCipher, _ padding: PaddingScheme) throws -> (Slice<ChunksOfCountCollection<Data>>, Data) {
		var blocks = text.chunks(ofCount: algorithm.blockSize)[...]  // cast to slice.
		let finalBlock: Data
		if text.count % algorithm.blockSize == 0 {
			if padding.ensureExists {
				finalBlock = try padding.pad(data: Data(), into: algorithm.blockSize)
			} else {
				finalBlock = Data(count: 0)
			}
		} else {
			guard let lastBlock = blocks.last else { throw MynaError.systemError }

			blocks = blocks.dropLast()

			finalBlock = try padding.pad(data: lastBlock, into: algorithm.blockSize)
		}

		guard finalBlock.count == algorithm.blockSize || finalBlock.isEmpty else { throw MynaError.invalidInputLength }
		return (blocks, finalBlock)
	}
}
