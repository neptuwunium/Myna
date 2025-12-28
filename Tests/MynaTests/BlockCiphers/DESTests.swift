// SPDX-FileCopyrightText: 2024-2026 Neptuwunium <ada@chronovore.dev>
// SPDX-License-Identifier: EUPL-1.2

import Foundation
import Testing

@testable import Myna

struct DESTests {
	@Test func keyScheduleTest() async throws {
		let des = DES(key: [0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef])
		let expected: DESKeySchedule = [
			[0x6464_9040, 0x42ce_40ca],
			[0x1490_9858, 0x4689_8586],
			[0xc4b4_4888, 0x8405_0b84],
			[0x9094_e438, 0x8184_814e],
			[0xd8a0_04f0, 0x05cc_0704],
			[0xa8f0_2810, 0x0107_84ca],
			[0xc840_48d8, 0x074a_8006],
			[0x68d8_04a8, 0x0701_c1c8],
			[0x0490_e40c, 0xcd49_4309],
			[0xac18_3024, 0xc8ce_0784],
			[0x24c0_7c10, 0xc18c_0885],
			[0x8c88_c038, 0x8a8a_4c82],
			[0xc048_c824, 0xc180_8383],
			[0x4c04_70a8, 0x0b86_c20b],
			[0x5840_20b4, 0xc84a_094a],
			[0x0074_2c4c, 0xce0c_0c44],
		]
		#expect(des.key.data.elementsEqual(expected.data))
	}

	@Test func roundTripTest() async throws {
		let des = DES(key: [0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef])
		var stimulus: Data = Data([1, 2, 3, 4, 5, 6, 7, 8])
		let stimulusCopy: Data = Data([1, 2, 3, 4, 5, 6, 7, 8])
		try des.encrypt(&stimulus)
		try des.decrypt(&stimulus)
		#expect(stimulus.elementsEqual(stimulusCopy))
	}

	@Test func encryptTest() async throws {
		let des = DES(key: [0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef])
		var encrypted = Data([1, 2, 3, 4, 5, 6, 7, 8])
		try des.encrypt(&encrypted)
		let reference = Data([0xe6, 0x8f, 0x79, 0x1b, 0xab, 0x16, 0xd4, 0xe6])
		#expect(encrypted.elementsEqual(reference))
	}

	@Test func decryptTest() async throws {
		let des = DES(key: [0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef])
		var decrypted = Data([0xe6, 0x8f, 0x79, 0x1b, 0xab, 0x16, 0xd4, 0xe6])
		try des.decrypt(&decrypted)
		let reference: Data = Data([1, 2, 3, 4, 5, 6, 7, 8])
		#expect(decrypted.elementsEqual(reference))
	}

	@Test func encryptFail() async throws {
		let des = DES(key: [0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef])
		#expect(throws: MynaError.invalidInputLength) {
			var data = Data([1])
			try des.encrypt(&data)
		}
	}

	@Test func decryptFail() async throws {
		let des = DES(key: [0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef])
		#expect(throws: MynaError.invalidInputLength) {
			var data = Data([1])
			try des.decrypt(&data)
		}
	}

	@Test func setOddParityTest() async throws {
		let key = DES.setOddParity(key: [0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xff])
		let stimulus: Data = Data([0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xfe])
		#expect(key.data.elementsEqual(stimulus))
	}

	@Test func stringToKey() async throws {
		let key = try DES.stringToKey(text: "Myna DES Str2Key TestVec")
		let stimulus: Data = Data([0x54, 0x73, 0xe6, 0xbc, 0xa8, 0x51, 0x20, 0x64])
		#expect(key.data.elementsEqual(stimulus))
	}

	@Test func stringToKeyUnaligned() async throws {
		let key = try DES.stringToKey(text: "Myna DES String to Key Test Vector")
		let stimulus: Data = Data([0x85, 0x40, 0x8f, 0xc4, 0x37, 0x57, 0x49, 0xef])
		#expect(key.data.elementsEqual(stimulus))
	}
}
