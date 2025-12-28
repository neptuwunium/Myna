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

	public func encrypt(_ plainText: borrowing Data) throws -> Data {
		if plainText.count == 0 { return Data() }

		let (blocks, finalBlock) = try TransformHelper.prepareBlocks(plainText: plainText, algorithm, padding)

		let blockSize = algorithm.blockSize
		var result = Data(count: blocks.count * blockSize + finalBlock.count)
		var previousBlock = self.iv
		var workingBlock = Data(count: blockSize)

		try result.withUnsafeMutableBytes { resultPtr in
			var offset = 0
			guard let resultBasePtr = resultPtr.baseAddress else {
				throw MynaError.systemError
			}

			let resultBase = resultBasePtr.assumingMemoryBound(to: UInt8.self)

			for block in blocks {
				workingBlock.replaceSubrange(0 ..< blockSize, with: block)
				workingBlock.xor(inplace: previousBlock)
				try algorithm.encrypt(&workingBlock)
				previousBlock.replaceSubrange(0 ..< blockSize, with: workingBlock)
				workingBlock.copyBytes(to: resultBase.advanced(by: offset), count: blockSize)
				offset += blockSize
			}

			if !finalBlock.isEmpty {
				workingBlock.replaceSubrange(0 ..< blockSize, with: finalBlock)
				workingBlock.xor(inplace: previousBlock)
				try algorithm.encrypt(&workingBlock)
				workingBlock.copyBytes(to: resultBase.advanced(by: offset), count: blockSize)
			}
		}

		return result
	}

	public func decrypt(_ cipherText: borrowing Data) throws -> Data {
		guard cipherText.count % algorithm.blockSize == 0 else { throw MynaError.invalidInputLength }

		if cipherText.count == 0 { return Data() }

		let blockSize = algorithm.blockSize
		let (blocks, blockCount, finalBlock) = try TransformHelper.prepareBlocks(cipherText: cipherText, algorithm)

		var result = Data(count: (blockCount - 1) * blockSize)
		var previousBlock = self.iv
		var workingBlock = Data(count: blockSize)

		if let blocks = blocks {
			try result.withUnsafeMutableBytes { resultPtr in
				var offset = 0
				guard let resultBasePtr = resultPtr.baseAddress else {
					throw MynaError.systemError
				}

				let resultBase = resultBasePtr.assumingMemoryBound(to: UInt8.self)

				for block in blocks {
					workingBlock.replaceSubrange(0 ..< blockSize, with: block)
					try algorithm.decrypt(&workingBlock)
					workingBlock.xor(inplace: previousBlock)

					previousBlock.replaceSubrange(0 ..< blockSize, with: block)

					workingBlock.copyBytes(to: resultBase.advanced(by: offset), count: blockSize)
					offset += blockSize
				}
			}
		}

		workingBlock.replaceSubrange(0 ..< blockSize, with: finalBlock)
		try algorithm.decrypt(&workingBlock)
		workingBlock.xor(inplace: previousBlock)
		result.append(try padding.unpad(data: workingBlock))

		return result
	}
}
