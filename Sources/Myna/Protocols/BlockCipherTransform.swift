// SPDX-FileCopyrightText: 2024-2026 Neptuwunium <ada@chronovore.dev>
// SPDX-License-Identifier: EUPL-1.2

import Foundation

/// Methods required for transforming data using a block-based transform.
// todo: refactor into .update / .finalize style
public protocol BlockCipherTransform {
	/// Encrypts the given data.
	///
	/// - Parameter plainText: The `Data` object to be encrypted. This may be larger than a single block.
	/// - Throws: `MynaError.invalidInputLength` if the input data or padding is invalid.
	/// - Rethrows: Any error thrown by the underlying `SymmetricAlgorithm` or `PaddingScheme`.
	/// - Returns: The encrypted `Data` object.
	func encrypt(_ plainText: borrowing Data) throws -> Data

	/// Decrypts the given data.
	///
	/// - Parameter cipherText: The `Data` object to be decrypted. This may be larger than a single block.
	/// - Throws: `MynaError.invalidInputLength` if the input data size is not a multiple of the block size.
	/// - Rethrows: Any error thrown by the underlying `SymmetricAlgorithm` or `PaddingScheme`.
	/// - Returns: The decrypted `Data` object.
	func decrypt(_ cipherText: borrowing Data) throws -> Data
}
