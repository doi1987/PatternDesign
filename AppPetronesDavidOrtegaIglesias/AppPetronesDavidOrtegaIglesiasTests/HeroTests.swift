//
//  DragonBallHeroTests.swift
//  AppPetronesDavidOrtegaIglesiasTests
//
//  Created by David Ortega Iglesias on 28/1/24.
//

import XCTest
@testable import AppPetronesDavidOrtegaIglesias

final class HeroTests: XCTestCase {

	func testGivenSameHeroesWhenCompareThenMatch() throws {
		let firstHero: HeroModel = .init(id: "1", name: "Goku", description: "des", photo: "", favorite: true)
		let secondHero: HeroModel = .init(id: "1", name: "Goku", description: "des", photo: "", favorite: true)
		XCTAssertEqual(firstHero, secondHero)
	}

	func testGivenDifferentHeroesWhenCompareThenMatch() {
		let firstHero: HeroModel = .init(id: "2", name: "Vegeta", description: "desc", photo: "", favorite: false)
		let secondHero: HeroModel = .init(id: "1", name: "Goku", description: "des", photo: "", favorite: true)
		XCTAssertNotEqual(firstHero, secondHero)
	}
	
	func testGivenHeroWhenCompareThenMatchData() throws {
		let hero = HeroModel(id: "1", name: "Goku", description: "des", photo: "", favorite: true)
		
		XCTAssertNotNil(hero)
		XCTAssertEqual(hero.name, "Goku")
		XCTAssertEqual(hero.id, "1")
		XCTAssertEqual(hero.description, "des")
		XCTAssertEqual(hero.favorite, true)
		XCTAssertEqual(hero.photo, "")
	}
}
