// SPDX-FileCopyrightText: 2024-2026 Neptuwunium <ada@chronovore.dev>
// SPDX-License-Identifier: EUPL-1.2

import Foundation

/// A block transformation implementation for the Electronic Code Book (ECB) mode of operation.
///
/// - Note: This transform is considered cryptographically unsafe.
public struct ECBTransform: BlockCipherTransform {
	private let algorithm: BlockCipher
	private let padding: PaddingScheme

	public init(algorithm: BlockCipher, paddingMode: PaddingScheme?) {
		self.algorithm = algorithm
		padding = paddingMode ?? PKCS7Padding()
	}

	public func encrypt(_ plainText: borrowing Data) throws -> Data {
		if plainText.count == 0 { return Data() }

		let (blocks, finalBlock) = try TransformHelper.prepareBlocks(plainText: plainText, algorithm, padding)

		let blockSize = algorithm.blockSize
		var result = Data(count: blocks.count * blockSize + finalBlock.count)
		var workingBlock = Data(count: blockSize)

		try result.withUnsafeMutableBytes { resultPtr in
			var offset = 0
			guard let resultBasePtr = resultPtr.baseAddress else {
				throw MynaError.systemError
			}

			let resultBase = resultBasePtr.assumingMemoryBound(to: UInt8.self)

			for block in blocks {
				workingBlock.replaceSubrange(0 ..< blockSize, with: block)
				try algorithm.encrypt(&workingBlock)
				workingBlock.copyBytes(to: resultBase.advanced(by: offset), count: blockSize)
				offset += blockSize
			}

			if !finalBlock.isEmpty {
				workingBlock.replaceSubrange(0 ..< blockSize, with: finalBlock)
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
					workingBlock.copyBytes(to: resultBase.advanced(by: offset), count: blockSize)
					offset += blockSize
				}
			}
		}

		workingBlock.replaceSubrange(0 ..< blockSize, with: finalBlock)
		try algorithm.decrypt(&workingBlock)
		result.append(try padding.unpad(data: workingBlock))

		return result
	}
}
