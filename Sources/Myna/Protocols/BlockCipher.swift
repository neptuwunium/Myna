// SPDX-FileCopyrightText: 2024-2026 Neptuwunium <ada@chronovore.dev>
// SPDX-License-Identifier: EUPL-1.2

import Foundation

/// Methods required for a block cipher.
// todo: refactor to use [UInt8] instaed of Data
public protocol BlockCipher {
	/// The block size in bytes that the algorithm operates on.
	var blockSize: Int { get }

	/// Encrypts a single block of data.
	///
	/// - Parameter plainText: The `Data` block to be encrypted. The size of the block must match the `blockSize`.
	/// - Throws: `MynaError.invalidInputLength` if the input data is not exactly `blockSize`.
	func encrypt(_ plainText: inout Data) throws

	/// Decrypts a single block of data.
	///
	/// - Parameter cipherText: The `Data` block to be decrypted. The size of the block must match the `blockSize`.
	/// - Throws: `MynaError.invalidInputLength` if the input data is not exactly `blockSize`.
	func decrypt(_ cipherText: inout Data) throws
}
