// SPDX-FileCopyrightText: 2024 Legiayayana <ada@chronovore.dev>
// SPDX-License-Identifier: EUPL-1.2

public enum MynaError: Error {
	case systemError
	case unsupportedPlatform
	case unexpectedPadding
	case invalidKeyLength
	case invalidInputLength
}
