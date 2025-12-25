// SPDX-FileCopyrightText: 2024-2026 Neptuwunium <ada@chronovore.dev>
// SPDX-License-Identifier: EUPL-1.2

import Foundation
import Testing

@testable import Myna

struct XTEATests {
	@Test func roundTripTest() async throws {
		let xtea = XTEA(key: [1, 2, 3, 4])
		let stimulus: Data = Data([1, 2, 3, 4, 5, 6, 7, 8])
		let encrypted = try xtea.encrypt(stimulus)
		let decrypted = try xtea.decrypt(encrypted)
		#expect(decrypted.elementsEqual(stimulus))
	}

	@Test func encryptTest() async throws {
		let xtea = XTEA(key: [1, 2, 3, 4])
		let encrypted = try xtea.encrypt(Data([1, 2, 3, 4, 5, 6, 7, 8]))
		let reference = Data([0xba, 0x8d, 0xab, 0xc4, 0xba, 0x9e, 0xcf, 0x3e])
		#expect(encrypted.elementsEqual(reference))
	}

	@Test func decryptTest() async throws {
		let xtea = XTEA(key: [1, 2, 3, 4])
		let decrypted = try xtea.decrypt(Data([0xba, 0x8d, 0xab, 0xc4, 0xba, 0x9e, 0xcf, 0x3e]))
		let reference: Data = Data([1, 2, 3, 4, 5, 6, 7, 8])
		#expect(decrypted.elementsEqual(reference))
	}

	@Test func encryptFail() async throws {
		let xtea = XTEA(key: [1, 2, 3, 4])
		#expect(throws: MynaError.invalidInputLength) { try xtea.encrypt(Data([1])) }
	}

	@Test func decryptFail() async throws {
		let xtea = XTEA(key: [1, 2, 3, 4])
		#expect(throws: MynaError.invalidInputLength) { try xtea.decrypt(Data([1])) }
	}
}
