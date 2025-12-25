// SPDX-FileCopyrightText: 2024 Legiayayana <ada@chronovore.dev>
// SPDX-License-Identifier: EUPL-1.2

import Foundation

/// A padding implementation that uses zero'd bytes as padding.
///
/// Zero-padding appends zeros to data to ensure it fits into a specific block size
/// and removes trailing zeros during unpadding.
public struct ZeroPadding: PaddingScheme {
	public func unpad(data: Data) throws -> Data {
		let remain = data.reversed().count { value in
			value == 0
		}

		guard remain > 0 else {
			throw MynaError.unexpectedPadding
		}

		if remain == data.count {
			return Data()
		}

		return data[...(data.count - Int(remain) - 1)]
	}

	public func pad(data: Data, into: Int) throws -> Data {
		var block = Data(capacity: into)
		block.append(data)

		let remain = into - data.count
		if remain <= 0 {
			throw MynaError.invalidInputLength
		}
		block.append(contentsOf: Array(repeating: 0, count: remain))

		return block
	}
}
