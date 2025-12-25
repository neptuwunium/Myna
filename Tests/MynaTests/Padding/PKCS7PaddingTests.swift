// SPDX-FileCopyrightText: 2024 Legiayayana <ada@chronovore.dev>
// SPDX-License-Identifier: EUPL-1.2

import Foundation
import Testing

@testable import Myna

struct PKCS7PaddingTests {
	@Test func pad() async throws {
		let data = Data([0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff])
		let padding = PKCS7Padding()
		let padded = try padding.pad(data: data, into: 16)
		let expected = Data([0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07])
		#expect(padded.elementsEqual(expected))
	}

	@Test func unpad() async throws {
		let data = Data([0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07])
		let padding = PKCS7Padding()
		let unpadded = try padding.unpad(data: data)
		let expected = Data([0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff])
		#expect(unpadded.elementsEqual(expected))
	}

	@Test func padEmpty() async throws {
		let data = Data()
		let padding = PKCS7Padding()
		let padded = try padding.pad(data: data, into: 16)
		let expected = Data([0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10])
		#expect(padded.elementsEqual(expected))
	}

	@Test func unpadEmpty() async throws {
		let data = Data([0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10])
		let padding = PKCS7Padding()
		let unpadded = try padding.unpad(data: data)
		let expected = Data()
		#expect(unpadded.elementsEqual(expected))
	}

	@Test func padFail() async throws {
		let data = Data([0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff])
		let padding = PKCS7Padding()
		#expect(throws: MynaError.invalidInputLength) {
			try padding.pad(data: data, into: 8)
		}
	}

	@Test func unpadFailInvalid() async throws {
		let data = Data([0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x08])
		let padding = PKCS7Padding()
		#expect(throws: MynaError.unexpectedPadding) {
			try padding.unpad(data: data)
		}
	}

	@Test func unpadFailWrong() async throws {
		let data = Data([0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])
		let padding = PKCS7Padding()
		#expect(throws: MynaError.unexpectedPadding) {
			try padding.unpad(data: data)
		}
	}

	@Test func unpadFailOverflow() async throws {
		let data = Data([0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11])
		let padding = PKCS7Padding()
		#expect(throws: MynaError.unexpectedPadding) {
			try padding.unpad(data: data)
		}
	}

	@Test func unpadFailZero() async throws {
		let data = Data()
		let padding = PKCS7Padding()
		#expect(throws: MynaError.unexpectedPadding) {
			try padding.unpad(data: data)
		}
	}
}
