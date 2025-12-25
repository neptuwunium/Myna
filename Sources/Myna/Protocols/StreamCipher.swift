// SPDX-FileCopyrightText: 2024-2026 Neptuwunium <ada@chronovore.dev>
// SPDX-License-Identifier: EUPL-1.2

import Foundation

/// Methods required for a stream cipher.
// NOTE: we should refactor this to be actually streamable
public protocol StreamCipher {
	/// Encrypts a stream of data
	///
	/// - Parameter plainText: The `Data` stream to be encrypted.
	/// - Throws: `MynaError.invalidInputLength` if the input data is of invalid length.
	/// - Returns: The encrypted `Data` stream.
	func encrypt(_ plainText: Data) throws -> Data

	/// Decrypts a stream data.
	///
	/// - Parameter cipherText: The `Data` stream to be decrypted.
	/// - Throws: `MynaError.invalidInputLength` if the input data is of invalid length.
	/// - Returns: The decrypted `Data` stream.
	func decrypt(_ cipherText: Data) throws -> Data
}
