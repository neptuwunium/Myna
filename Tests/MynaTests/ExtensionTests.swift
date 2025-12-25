// SPDX-FileCopyrightText: 2024 Legiayayana <ada@chronovore.dev>
// SPDX-License-Identifier: EUPL-1.2

import Foundation
import Testing

@testable import Myna

struct IntExtensionTests {
	@Test func alignN() async throws {
		#expect(12.align(into: 16) == 16)
	}

	@Test func alignE() async throws {
		#expect(32.align(into: 16) == 32)
	}

	@Test func alignZ() async throws {
		#expect(0.align(into: 16) == 0)
	}
}

struct DataExtensionTests {
	@Test func xor() throws {
		let data1 = Data([1, 2, 3, 4, 5, 6])
		let data2 = Data([0x80, 0x80, 0x80, 0x80, 0x80, 0x80])
		let expected = Data([0x81, 0x82, 0x83, 0x84, 0x85, 0x86])
		#expect(data1.xor(other: data2).elementsEqual(expected))
	}
}
