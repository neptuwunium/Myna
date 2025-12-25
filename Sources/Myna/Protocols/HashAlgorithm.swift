// SPDX-FileCopyrightText: 2024 Legiayayana <ada@chronovore.dev>
// SPDX-License-Identifier: EUPL-1.2

import Foundation

/// Methods required for hashing data.
public protocol HashAlgorithm {
	associatedtype T

	/// The number of bits this hash yields.
	static var bitSize: Int { get }

	/// Hashes data from the `Data` buffer.
	///
	/// - Parameter data: the `Data` buffer to be hashed.
	func update(data: Data)

	/// Finalizes the hash buffer.
	/// - Returns: the hashed data value.
	func finalize() -> T

	/// One-shot hashes the data from the `Data` buffer
	/// - Parameter data: the `Data` buffer to be hashed.
	/// - Returns: the hashed data value.
	static func hash(data: Data) -> T
}
