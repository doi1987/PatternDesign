//
//  HomeUseCaseTests.swift
//  AppPetronesDavidOrtegaIglesiasTests
//
//  Created by David Ortega Iglesias on 28/1/24.
//

import XCTest

final class HomeUseCaseTests: XCTestCase {
	private var sut: HomeUseCaseProtocol!


    func testGivenHeroesWhenGetHeroesThenMatchSuccess() throws {
		let expected = [HeroModel(id: "1", name: "Diego", description: "Superman", photo: "", favorite: true) ,
						HeroModel(id: "2", name: "Alejandro", description: "Spiderman", photo: "", favorite: false),
						HeroModel(id: "3", name: "Rocio", description: "Super Woman", photo: "", favorite: true)]
		
		sut = HomeUseCaseFakeSuccess()
		let expectation = expectation(description: "Heroes success")
		var heroesOutput: [HeroModel]?
		
		sut.getHeroes { heroes in
			heroesOutput = heroes
			expectation.fulfill()
		} onError: { error in
			XCTFail("Test throws error")
		}

		wait(for: [expectation], timeout: 1)
		
		let heroesOutputResult = try XCTUnwrap(heroesOutput)
		XCTAssertEqual(heroesOutputResult, expected)
    }
	
	func testGivenHeroesWhenGetHeroesThenMatchOnError() throws {
		let expected = NetworkError.noData
		let expectation = expectation(description: "Heroes error No data")
		sut = HomeUseCaseFakeError()
		var errorOutput: NetworkError?
		
		sut.getHeroes { heroes in
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
