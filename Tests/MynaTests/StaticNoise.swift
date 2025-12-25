// SPDX-FileCopyrightText: 2024-2026 Neptuwunium <ada@chronovore.dev>
// SPDX-License-Identifier: EUPL-1.2

import Foundation
import Myna

public struct DummyNoise: RandomNoiseGenerator {
	public static let value: UInt8 = 0x93

	public func getBytes(count: Int) throws -> Data { Data(repeating: DummyNoise.value, count: count) }
}
