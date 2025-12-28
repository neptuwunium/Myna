// SPDX-FileCopyrightText: 2024-2026 Neptuwunium <ada@chronovore.dev>
// SPDX-License-Identifier: EUPL-1.2

import Foundation
import Testing

@testable import Myna

struct XTEATests {
	@Test func roundTripTest() async throws {
		let xtea = XTEA(key: [1, 2, 3, 4])
		var stimulus: Data = Data([1, 2, 3, 4, 5, 6, 7, 8])
		let stimulusCopy: Data = Data([1, 2, 3, 4, 5, 6, 7, 8])
		try xtea.encrypt(&stimulus)
		try xtea.decrypt(&stimulus)
		#expect(stimulus.elementsEqual(stimulusCopy))
	}

	@Test func encryptTest() async throws {
		let xtea = XTEA(key: [1, 2, 3, 4])
		var encrypted = Data([1, 2, 3, 4, 5, 6, 7, 8])
		try xtea.encrypt(&encrypted)
		let reference = Data([0xba, 0x8d, 0xab, 0xc4, 0xba, 0x9e, 0xcf, 0x3e])
		#expect(encrypted.elementsEqual(reference))
	}

	@Test func decryptTest() async throws {
		let xtea = XTEA(key: [1, 2, 3, 4])
		var decrypted = Data([0xba, 0x8d, 0xab, 0xc4, 0xba, 0x9e, 0xcf, 0x3e])
		try xtea.decrypt(&decrypted)
		let reference: Data = Data([1, 2, 3, 4, 5, 6, 7, 8])
		#expect(decrypted.elementsEqual(reference))
	}

	@Test func encryptFail() async throws {
		let xtea = XTEA(key: [1, 2, 3, 4])
		#expect(throws: MynaError.invalidInputLength) {
			var data = Data([1])
			try xtea.encrypt(&data)
		}
	}

	@Test func decryptFail() async throws {
		let xtea = XTEA(key: [1, 2, 3, 4])
		#expect(throws: MynaError.invalidInputLength) {
			var data = Data([1])
			try xtea.decrypt(&data)
		}
	}
}
