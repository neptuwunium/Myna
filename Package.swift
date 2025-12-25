// swift-tools-version: 6.0

// SPDX-FileCopyrightText: 2024 Legiayayana <ada@chronovore.dev>
// SPDX-License-Identifier: EUPL-1.2

import PackageDescription

let package = Package(
	name: "Myna",
	products: [
		.library(
			name: "Myna",
			targets: ["Myna"])
	],
	dependencies: [
		.package(url: "https://github.com/apple/swift-docc-plugin", from: "1.1.0"),
		.package(url: "https://github.com/apple/swift-algorithms", from: "1.2.0"),
	],
	targets: [
		.target(
			name: "Myna",
			dependencies: [
				.product(name: "Algorithms", package: "swift-algorithms")
			]
		),
		.testTarget(
			name: "MynaTests",
			dependencies: ["Myna"]
		),
	]
)
