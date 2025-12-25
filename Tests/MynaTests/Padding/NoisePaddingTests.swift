// SPDX-FileCopyrightText: 2024 Legiayayana <ada@chronovore.dev>
// SPDX-License-Identifier: EUPL-1.2

import Foundation
import Testing

@testable import Myna

struct NoisePaddingTests {
	@Test func pad() async throws {
		let data = Data([0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff])
		let padding = NoisePadding()
		let padded = try padding.pad(data: data, into: 16)
		// hard to test due to randomness
		let expected = Data([0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, padded[9], padded[10], padded[11], padded[12], padded[13], padded[14], padded[15]])
		#expect(padded.elementsEqual(expected))
	}

	@Test func unpad() async throws {
		let data = Data([0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x54, 0x2d, 0xf8, 0x79, 0xd7, 0x4d, 0xea])
		let padding = NoisePadding()
		let unpadded = try padding.unpad(data: data)
		#expect(unpadded.elementsEqual(data))
	}

	@Test func padEmpty() async throws {
		let data = Data()
		let padding = NoisePadding()
		let padded = try padding.pad(data: data, into: 16)
		#expect(padded.count == 16)
	}

	@Test func unpadEmpty() async throws {
		let data = Data([0xdf, 0xf1, 0x12, 0xd8, 0x96, 0x5f, 0x51, 0x30, 0xbb, 0x54, 0x2d, 0xf8, 0x79, 0xd7, 0x4d, 0xea])
		let padding = NoisePadding()
		let unpadded = try padding.unpad(data: data)
		#expect(unpadded.elementsEqual(data))
	}

	@Test func padFail() async throws {
		let data = Data([0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff])
		let padding = NoisePadding()
		#expect(throws: MynaError.invalidInputLength) {
			try padding.pad(data: data, into: 1)
		}
	}
}
