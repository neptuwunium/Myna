// SPDX-FileCopyrightText: 2024-2026 Neptuwunium <ada@chronovore.dev>
// SPDX-License-Identifier: EUPL-1.2

import Algorithms
import Foundation

/// A block transformation implementation for the Electronic Code Book (ECB) mode of operation.
///
/// - Note: This transform is considered cryptographically unsafe.
public struct ECBTransform: BlockCipherTransform {
	private let algorithm: BlockCipher
	private let padding: PaddingScheme

	init(algorithm: BlockCipher, paddingMode: PaddingScheme?) {
		self.algorithm = algorithm
		padding = paddingMode ?? PKCS7Padding()
	}

	public func encrypt(_ plainText: Data) throws -> Data {
		if plainText.count == 0 { return Data() }

		var result = Data(capacity: plainText.count.align(into: algorithm.blockSize))
		var blocks = plainText.chunks(ofCount: algorithm.blockSize)[...]  // cast to slice.
		let finalBlock: Data
		if plainText.count % algorithm.blockSize == 0 {
			finalBlock = try padding.pad(data: Data(), into: algorithm.blockSize)
		} else {
			blocks = blocks.dropLast()

			guard let lastBlock = blocks.last else { throw MynaError.systemError }

			finalBlock = try padding.pad(data: lastBlock, into: algorithm.blockSize)
		}

		guard finalBlock.count == algorithm.blockSize || finalBlock.count == 0 else { throw MynaError.invalidInputLength }

		for block in blocks { result.append(try algorithm.encrypt(block)) }

		result.append(try algorithm.encrypt(finalBlock))

		return result
	}

	public func decrypt(_ cipherText: Data) throws -> Data {
		guard cipherText.count % algorithm.blockSize == 0 else { throw MynaError.invalidInputLength }

		if cipherText.count == 0 { return Data() }

		var result = Data(capacity: cipherText.count.align(into: algorithm.blockSize))
		let blocks = cipherText.chunks(ofCount: algorithm.blockSize)

		for block in blocks.dropLast() { result.append(try algorithm.decrypt(block)) }

		guard let lastBlock = blocks.last else { throw MynaError.systemError }

		let finalBlock = try algorithm.decrypt(lastBlock)
		result.append(try padding.unpad(data: finalBlock))
		return result
	}
}
