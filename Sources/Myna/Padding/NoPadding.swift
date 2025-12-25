// SPDX-FileCopyrightText: 2024 Legiayayana <ada@chronovore.dev>
// SPDX-License-Identifier: EUPL-1.2

import Foundation

/// A padding implementation that does nothing.
public struct NoPadding: PaddingScheme {
	public func unpad(data: Data) -> Data {
		return data
	}

	public func pad(data: Data, into: Int) throws -> Data {
		guard data.count == into || data.count == 0 else {
			throw MynaError.invalidInputLength
		}

		return data
	}
}
