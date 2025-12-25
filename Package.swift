// swift-tools-version: 6.2

// SPDX-FileCopyrightText: 2024-2026 Neptuwunium <ada@chronovore.dev>
// SPDX-License-Identifier: EUPL-1.2

import PackageDescription

let package = Package(
	name: "Myna",
	products: [
		.library(name: "Myna", targets: ["Myna"])
	],
	dependencies: [
		.package(url: "https://github.com/swiftlang/swift-docc-plugin", from: "1.4.5"),
		.package(url: "https://github.com/apple/swift-algorithms", from: "1.2.1"),
	],
	targets: [
		.target(name: "Myna", dependencies: [.product(name: "Algorithms", package: "swift-algorithms")]), .testTarget(name: "MynaTests", dependencies: ["Myna"]),
	])
