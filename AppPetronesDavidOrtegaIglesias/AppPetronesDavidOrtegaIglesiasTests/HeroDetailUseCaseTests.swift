//
//  HeroDetailUseCaseTests.swift
//  AppPetronesDavidOrtegaIglesiasTests
//
//  Created by David Ortega Iglesias on 28/1/24.
//

import XCTest

@testable import AppPetronesDavidOrtegaIglesias

final class HeroDetailUseCaseTests: XCTestCase {
	private var sut: HeroDetailUseCaseProtocol!
	
	func testGivenNameWhenGetHeroesThenMatchSuccess() throws {
		let name = String.randomString()
		let expected = [HeroModel(id: "1", name: name, description: "Superman", photo: "", favorite: true)]
		
		sut = HeroDetailUseCaseFakeSuccess()
		let expectation = expectation(description: "Heroes detail success")
		var heroOutput: [HeroModel]?
		
		sut.getHeroDetail(name: name) { heroes in
			heroOutput = heroes
			expectation.fulfill()
		} onError: { error in
			XCTFail("Test throws error")
		}
		
		wait(for: [expectation], timeout: 1)
		
		let heroOutputResult = try XCTUnwrap(heroOutput)
		XCTAssertEqual(heroOutputResult, expected)
	}
 
 func testGivenHeroesWhenGetHeroesThenMatchOnError() throws {
	 let expected = NetworkError.malformedURL
	 let expectation = expectation(description: "Hero error")
	 sut = HeroDetailUseCaseFakeError()
	 var errorOutput: NetworkError?
	 
	 sut.getHeroDetail(name: String.randomString()) { heroes in
		 XCTFail("Test throws Success")
	 } onError: { error in
		 errorOutput = error
		 expectation.fulfill()
	 }
	 
	 wait(for: [expectation], timeout: 1)
	 let errorResult = try XCTUnwrap(errorOutput)
	 XCTAssertEqual(errorResult, expected)
 }
}
