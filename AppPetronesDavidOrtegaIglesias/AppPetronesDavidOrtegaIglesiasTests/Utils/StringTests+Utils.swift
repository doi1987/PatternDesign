//
//  StringTests+Utils.swift
//  AppPetronesDavidOrtegaIglesiasTests
//
//  Created by David Ortega Iglesias on 28/1/24.
//

import Foundation

extension String {
	static func randomString(length: Int = Int.random(in: 1...10)) -> String {
		let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
		return String((0..<length).map{ _ in letters.randomElement()! })
	}
}
