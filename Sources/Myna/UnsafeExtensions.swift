// SPDX-FileCopyrightText: 2024 Legiayayana <ada@chronovore.dev>
// SPDX-License-Identifier: EUPL-1.2

import Foundation

#if os(macOS) || os(iOS)
	import Security
#elseif canImport(Glibc)
	import Glibc
#elseif canImport(Musl)
	import Musl
#elseif canImport(WinSDK)
	import WinSDK
#endif

extension Data {
	static func random(count: Int) throws -> Data {
		var data = Data(count: count)
		let success = data.withUnsafeMutableBytes { mutablePointer in
			guard count > 0 else {
				return false
			}

			guard let unsafeMutablePointer = mutablePointer.baseAddress else {
				return false
			}

			let unsafePointer = unsafeMutablePointer.assumingMemoryBound(to: UInt8.self)

			#if os(macOS) || os(iOS)
				return SecRandomCopyBytes(kSecRandomDefault, count, unsafePointer) == errSecSuccess
			#elseif canImport(Glibc) || canImport(Musl)
				return getentropy(unsafePointer, count) == 0
			#elseif canImport(WinSDK)
				return BCryptGenRandom(nil, unsafePointer, count, BCRYPT_USE_SYSTEM_PREFERRED_RNG) == 0
			#else
				throw MynaError.unsupportedPlatform
			#endif
		}

		guard success else {
			throw MynaError.systemError
		}

		return data
	}
}
