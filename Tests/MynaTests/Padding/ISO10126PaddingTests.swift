// SPDX-FileCopyrightText: 2024-2026 Neptuwunium <ada@chronovore.dev>
// SPDX-License-Identifier: EUPL-1.2

import Foundation
import Testing

@testable import Myna

struct ISO10126PaddingTests {
	@Test func pad() async throws {
		let data = Data([0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff])
		let padding = ISO10126Padding(noise: DummyNoise())
		let padded = try padding.pad(data: data, into: 16)
		let expected = Data([0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, DummyNoise.value, DummyNoise.value, DummyNoise.value, DummyNoise.value, DummyNoise.value, DummyNoise.value, 0x07])
		#expect(padded.elementsEqual(expected))
	}

	@Test func unpad() async throws {
		let data = Data([0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x54, 0x2d, 0xf8, 0x79, 0xd7, 0x4d, 0x07])
		let padding = ISO10126Padding()
		let unpadded = try padding.unpad(data: data)
		let expected = Data([0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff])
		#expect(unpadded.elementsEqual(expected))
	}

	@Test func padEmpty() async throws {
		let data = Data()
		let padding = ISO10126Padding(noise: DummyNoise())
		let padded = try padding.pad(data: data, into: 16)
		var expected = Data(repeating: DummyNoise.value, count: 16)
		expected[15] = 0x10
		#expect(padded.elementsEqual(expected))
	}

	@Test func unpadEmpty() async throws {
		let data = Data([0xdf, 0xf1, 0x12, 0xd8, 0x96, 0x5f, 0x51, 0x30, 0xbb, 0x54, 0x2d, 0xf8, 0x79, 0xd7, 0x4d, 0x10])
		let padding = ISO10126Padding()
		let unpadded = try padding.unpad(data: data)
		let expected = Data()
		#expect(unpadded.elementsEqual(expected))
	}

	@Test func padFail() async throws {
		let data = Data([0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff])
		let padding = ISO10126Padding()
		#expect(throws: MynaError.invalidInputLength) { try padding.pad(data: data, into: 8) }
	}

	@Test func unpadFailWrong() async throws {
		let data = Data([0xdf, 0xf1, 0x12, 0xd8, 0x96, 0x5f, 0x51, 0x30, 0xbb, 0x54, 0x2d, 0xf8, 0x79, 0xd7, 0x4d, 0x00])
		let padding = ISO10126Padding()
		#expect(throws: MynaError.unexpectedPadding) { try padding.unpad(data: data) }
	}

	@Test func unpadFailOverflow() async throws {
		let data = Data([0xdf, 0xf1, 0x12, 0xd8, 0x96, 0x5f, 0x51, 0x30, 0xbb, 0x54, 0x2d, 0xf8, 0x79, 0xd7, 0x4d, 0x11])
		let padding = ISO10126Padding()
		#expect(throws: MynaError.unexpectedPadding) { try padding.unpad(data: data) }
	}

	@Test func unpadFailZero() async throws {
		let data = Data()
		let padding = ISO10126Padding()
		#expect(throws: MynaError.unexpectedPadding) { try padding.unpad(data: data) }
	}
}
