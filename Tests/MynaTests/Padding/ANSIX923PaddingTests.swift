// SPDX-FileCopyrightText: 2024 Legiayayana <ada@chronovore.dev>
// SPDX-License-Identifier: EUPL-1.2

import Foundation
import Testing

@testable import Myna

struct ANSIX923PaddingTests {
	@Test func pad() async throws {
		let data = Data([0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff])
		let padding = ANSIX923Padding()
		let padded = try padding.pad(data: data, into: 16)
		let expected = Data([0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x07])
		#expect(padded.elementsEqual(expected))
	}

	@Test func unpad() async throws {
		let data = Data([0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x07])
		let padding = ANSIX923Padding()
		let unpadded = try padding.unpad(data: data)
		let expected = Data([0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff])
		#expect(unpadded.elementsEqual(expected))
	}

	@Test func padEmpty() async throws {
		let data = Data()
		let padding = ANSIX923Padding()
		let padded = try padding.pad(data: data, into: 16)
		let expected = Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x10])
		#expect(padded.elementsEqual(expected))
	}

	@Test func unpadEmpty() async throws {
		let data = Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x10])
		let padding = ANSIX923Padding()
		let unpadded = try padding.unpad(data: data)
		let expected = Data()
		#expect(unpadded.elementsEqual(expected))
	}

	@Test func padFail() async throws {
		let data = Data([0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff])
		let padding = ANSIX923Padding()
		#expect(throws: MynaError.invalidInputLength) {
			try padding.pad(data: data, into: 8)
		}
	}

	@Test func unpadFailInvalid() async throws {
		let data = Data([0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x08])
		let padding = ANSIX923Padding()
		#expect(throws: MynaError.unexpectedPadding) {
			try padding.unpad(data: data)
		}
	}

	@Test func unpadFailWrong() async throws {
		let data = Data([0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])
		let padding = ANSIX923Padding()
		#expect(throws: MynaError.unexpectedPadding) {
			try padding.unpad(data: data)
		}
	}

	@Test func unpadFailOverflow() async throws {
		let data = Data([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x11])
		let padding = ANSIX923Padding()
		#expect(throws: MynaError.unexpectedPadding) {
			try padding.unpad(data: data)
		}
	}

	@Test func unpadFailZero() async throws {
		let data = Data()
		let padding = ANSIX923Padding()
		#expect(throws: MynaError.unexpectedPadding) {
			try padding.unpad(data: data)
		}
	}
}
