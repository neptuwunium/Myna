// SPDX-FileCopyrightText: 2024 Legiayayana <ada@chronovore.dev>
// SPDX-License-Identifier: EUPL-1.2

import Foundation
import Testing

@testable import Myna

struct UnsafeDataExtensionTests {
	@Test func random() async throws {
		let data = try Data.random(count: 16)
		#expect(data.count == 16)
		#expect(
			!data.allSatisfy { value in
				value == 0
			})
	}

	@Test func randomZero() async throws {
		#expect(throws: MynaError.systemError) {
			try Data.random(count: 0)
		}
	}
}
