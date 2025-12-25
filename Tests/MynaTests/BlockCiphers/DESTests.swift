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
}
