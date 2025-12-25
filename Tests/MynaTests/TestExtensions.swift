// SPDX-FileCopyrightText: 2024 Legiayayana <ada@chronovore.dev>
// SPDX-License-Identifier: EUPL-1.2

import Foundation

extension Data {
	func hex() -> String {
		map { String(format: "%02hhx", $0) }.joined()
	}
}
