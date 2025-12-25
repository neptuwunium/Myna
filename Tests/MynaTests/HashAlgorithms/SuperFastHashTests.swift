// SPDX-FileCopyrightText: 2024-2026 Neptuwunium <ada@chronovore.dev>
// SPDX-License-Identifier: EUPL-1.2

import Foundation
import Testing

@testable import Myna

struct SuperFastHashTests {
	@Test func noOverflow() async throws {
		let hash = SuperFastHash.hash("1234")
		#expect(hash == 0xd178_1478)
	}

	@Test func underOverflow() async throws {
		let hash = SuperFastHash.hash("123")
		#expect(hash == 0x3ce9_e2b1)
	}

	@Test func oneOverflow() async throws {
		let hash = SuperFastHash.hash("12345")
		#expect(hash == 0x2d79_521a)
	}

	@Test func twoOverflow() async throws {
		let hash = SuperFastHash.hash("123456")
		#expect(hash == 0x05ad_dbcf)
	}

	@Test func threeOverflow() async throws {
		let hash = SuperFastHash.hash("1234567")
		#expect(hash == 0x1ec6_a083)
	}

	@Test func textString() async throws {
		let hash = SuperFastHash.hash("The quick brown fox jumps over the lazy dog")
		#expect(hash == 0x1c19_ee97)
	}

	@Test func textStringAlignedSplit() async throws {
		var hasher = SuperFastHash()
		hasher.update(Data("The ".utf8))
		hasher.update(Data("quick brown fox jumps over the lazy dog".utf8))
		let hash = hasher.finalize()
		#expect(hash == 0x1c19_ee97)
	}

	@Test func textStringUnalignedSplit() async throws {
		var hasher = SuperFastHash()
		hasher.update(Data("The".utf8))
		hasher.update(Data(" quick brown fox jumps over the lazy dog".utf8))
		let hash = hasher.finalize()
		#expect(hash == 0x1c19_ee97)
	}
}
