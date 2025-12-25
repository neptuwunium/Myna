// SPDX-FileCopyrightText: 2024 Legiayayana <ada@chronovore.dev>
// SPDX-License-Identifier: EUPL-1.2

import Foundation
import Testing

@testable import Myna

struct NoPaddingTests {
	@Test func pad() async throws {
		let data = Data([0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff])
		let padding: NoPadding = NoPadding()
		let padded = try padding.pad(data: data, into: 8)
		#expect(padded.elementsEqual(data))
	}

	@Test func unpad() async throws {
		let data: Data = Data([0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff])
		let padding = NoPadding()
		let unpadded = padding.unpad(data: data)
		#expect(unpadded.elementsEqual(data))
	}

	@Test func padEmpty() async throws {
		let data: Data = Data()
		let padding = NoPadding()
		let padded = try padding.pad(data: data, into: 8)
		#expect(padded.elementsEqual(data))
	}

	@Test func unpadEmpty() async throws {
		let data: Data = Data()
		let padding = NoPadding()
		let unpadded = padding.unpad(data: data)
		#expect(unpadded.elementsEqual(data))
	}

	@Test func padFail() async throws {
		let data = Data([0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff])
		let padding = NoPadding()
		#expect(throws: MynaError.invalidInputLength) {
			try padding.pad(data: data, into: 1)
		}
	}
}
