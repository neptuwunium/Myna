// SPDX-FileCopyrightText: 2024-2026 Neptuwunium <ada@chronovore.dev>
// SPDX-License-Identifier: EUPL-1.2

import Algorithms
import Foundation

internal struct TransformHelper {
	private init() {}

	internal static func prepareBlocks(plainText text: Data, _ algorithm: BlockCipher, _ padding: PaddingScheme) throws -> (ChunksOfCountCollection<Data>, Data) {
		let blockSize = algorithm.blockSize
		let totalLen = text.count

		let remainder = totalLen % blockSize
		let hasRemainder = remainder > 0

		let endIndex: Int
		let finalBlock: Data

		if hasRemainder {
			endIndex = totalLen - remainder
			let lastPartial = text.suffix(remainder)
			finalBlock = try padding.pad(data: Data(lastPartial), into: blockSize)
		} else {
			if padding.ensureExists {
				endIndex = totalLen
				finalBlock = try padding.pad(data: Data(), into: blockSize)
			} else {
				endIndex = totalLen
				finalBlock = Data()
			}
		}

		let blocks = text.prefix(endIndex).chunks(ofCount: blockSize)

		return (blocks, finalBlock)
	}

	internal static func prepareBlocks(cipherText text: Data, _ algorithm: BlockCipher) throws -> (ChunksOfCountCollection<Data>?, Int, Data) {
		let blockSize = algorithm.blockSize
		let totalLen = text.count

		guard totalLen > blockSize else {
			return (nil, 1, text)
		}

		let blocks = text.prefix(totalLen - blockSize).chunks(ofCount: blockSize)
		let finalBlock = text.suffix(blockSize)
		return (blocks, totalLen / blockSize, finalBlock)
	}
}
