// SPDX-FileCopyrightText: 2024 Legiayayana <ada@chronovore.dev>
// SPDX-License-Identifier: EUPL-1.2

import Foundation

/// Methods for data padding and unpadding.
public protocol PaddingScheme {
	/// Removes padding bytes from the given data.
	///
	/// - Parameter data: The padded `Data` object to be unpadded.
	/// - Throws: `MynaError.unexpectedPadding` if the padding format is invalid or no padding is found.
	/// - Returns: The unpadded `Data` object.
	func unpad(data: Data) throws -> Data

	/// Pads the given data to the specified length.
	///
	/// - Parameters:
	///   - data: The `Data` object to be padded.
	///   - into: The desired block size to which the data should be padded.
	/// - Throws: `MynaError.invalidInputLength` if the input data's size is not a block size
	/// - Returns: The padded `Data` object.
	func pad(data: Data, into: Int) throws -> Data
}
