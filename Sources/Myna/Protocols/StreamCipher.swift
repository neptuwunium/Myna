// SPDX-FileCopyrightText: 2024 Legiayayana <ada@chronovore.dev>
// SPDX-License-Identifier: EUPL-1.2

import Foundation

/// Methods required for a stream cipher.
public protocol StreamCipher {
	/// Encrypts a stream of data
	///
	/// - Parameter data: The `Data` stream to be encrypted.
	/// - Throws: `MynaError.invalidInputLength` if the input data is of invalid length.
	/// - Returns: The encrypted `Data` stream.
	func encrypt(data: Data) throws -> Data

	/// Decrypts a stream data.
	///
	/// - Parameter data: The `Data` stream to be decrypted.
	/// - Throws: `MynaError.invalidInputLength` if the input data is of invalid length.
	/// - Returns: The decrypted `Data` stream.
	func decrypt(data: Data) throws -> Data
}
