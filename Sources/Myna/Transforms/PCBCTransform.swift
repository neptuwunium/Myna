// SPDX-FileCopyrightText: 2024-2026 Neptuwunium <ada@chronovore.dev>
// SPDX-License-Identifier: EUPL-1.2

import Algorithms
import Foundation

/// A block transformation implementation for the Permutating Cipher Block Chaining (PCBC) mode of operation.
public struct PCBCTransform: BlockCipherTransform {
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
			let tmp = try algorithm.encrypt(block.xor(with: previousBlock))
			previousBlock = block.xor(with: tmp)
			result.append(tmp)
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

		var result = Data(capacity: blocks.count * algorithm.blockSize)
		var previousBlock = self.iv

		for block in blocks.dropLast() {
			let tmp = try algorithm.decrypt(block).xor(with: previousBlock)
			previousBlock = tmp.xor(with: block)
			result.append(tmp)
		}

		guard let lastBlock = blocks.last else { throw MynaError.systemError }

		let finalBlock = try algorithm.decrypt(lastBlock).xor(with: previousBlock)
		result.append(try padding.unpad(data: finalBlock))

		return result
	}
}
