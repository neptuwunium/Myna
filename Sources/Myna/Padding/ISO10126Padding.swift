// SPDX-FileCopyrightText: 2024 Legiayayana <ada@chronovore.dev>
// SPDX-License-Identifier: EUPL-1.2

import Foundation

/// A padding implementation that conforms to the ISO-10126 standard.
///
/// ISO10126 fills the remaining bytes with random noise, sets the final
/// byte to the number of padding bytes added.
public struct ISO10126Padding: PaddingScheme {
	public func unpad(data: Data) throws -> Data {
		if let remain = data.last {
			guard remain != 0 else {
				throw MynaError.unexpectedPadding
			}

			guard remain <= data.count else {
				throw MynaError.unexpectedPadding
			}

			if remain == data.count {
				return Data()
			}

			return data[...(data.count - Int(remain) - 1)]
		}

		throw MynaError.unexpectedPadding
	}

	public func pad(data: Data, into: Int) throws -> Data {
		var block = Data(capacity: into)
		block.append(data)

		let remain = into - data.count
		guard remain > 0 else {
			throw MynaError.invalidInputLength
		}

		block.append(try Data.random(count: remain - 1))
		block.append(UInt8(remain))

		return block
	}
}
