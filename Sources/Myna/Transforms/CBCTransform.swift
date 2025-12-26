// SPDX-FileCopyrightText: 2024-2026 Neptuwunium <ada@chronovore.dev>
// SPDX-License-Identifier: EUPL-1.2

import Algorithms
import Foundation

/// A block transformation implementation for the Cipher Block Chaining (CBC) mode of operation.
public struct CBCTransform: BlockCipherTransform {
	private let algorithm: BlockCipher
	private let padding: PaddingScheme
	private var iv: Data

	public init(algorithm: BlockCipher, iv: Data?, paddingMode: PaddingScheme?) {
		self.algorithm = algorithm
		self.iv = iv ?? Data(count: algorithm.blockSize)
		padding = paddingMode ?? PKCS7Padding()
	}

	public func encrypt(_ plainText: Data) throws -> Data {
		if plainText.count == 0 { return Data() }

		let (blocks, finalBlock) = try TransformHelper.prepareBlocks(text: plainText, algorithm, padding)

		var result = Data(capacity: plainText.count.align(into: algorithm.blockSize))
		var previousBlock = self.iv

		for block in blocks {
			previousBlock = try algorithm.encrypt(block.xor(with: previousBlock))
			result.append(previousBlock)
		}

		if !finalBlock.isEmpty {
			result.append(try algorithm.encrypt(finalBlock.xor(with: previousBlock)))
		}

		return result
	}

	public func decrypt(_ cipherText: Data) throws -> Data {
		guard cipherText.count % algorithm.blockSize == 0 else { throw MynaError.invalidInputLength }

		if cipherText.count == 0 { return Data() }

		let blocks = cipherText.chunks(ofCount: algorithm.blockSize)
		var previousBlock = self.iv

		var result = Data(capacity: blocks.count * algorithm.blockSize)

		for block in blocks.dropLast() {
			result.append(try algorithm.decrypt(block).xor(with: previousBlock))
			previousBlock = block
		}

		guard let lastBlock = blocks.last else { throw MynaError.systemError }

		let finalBlock = try algorithm.decrypt(lastBlock).xor(with: previousBlock)
		result.append(try padding.unpad(data: finalBlock))

		return result
	}
}
