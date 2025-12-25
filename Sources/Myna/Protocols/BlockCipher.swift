// SPDX-FileCopyrightText: 2024 Legiayayana <ada@chronovore.dev>
// SPDX-License-Identifier: EUPL-1.2

import Foundation

/// Methods required for a block cipher.
public protocol BlockCipher {
	/// The block size in bytes that the algorithm operates on.
	var blockSize: Int { get }

	/// Encrypts a single block of data.
	///
	/// - Parameter block: The `Data` block to be encrypted. The size of the block must match the `blockSize`.
	/// - Throws: `MynaError.invalidInputLength` if the input data is not exactly `blockSize`.
	/// - Returns: The encrypted `Data` block.
	func encrypt(block: Data) throws -> Data

	/// Decrypts a single block of data.
	///
	/// - Parameter block: The `Data` block to be decrypted. The size of the block must match the `blockSize`.
	/// - Throws: `MynaError.invalidInputLength` if the input data is not exactly `blockSize`.
	/// - Returns: The decrypted `Data` block.
	func decrypt(block: Data) throws -> Data
}
