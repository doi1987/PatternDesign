//
//  HeroDetailUseCaseTests.swift
//  AppPetronesDavidOrtegaIglesiasTests
//
//  Created by David Ortega Iglesias on 28/1/24.
//

import XCTest

@testable import AppPetronesDavidOrtegaIglesias

final class TransformationTableUseCaseTests: XCTestCase {
	private var sut: TransformationTableUseCaseProtocol!
	
	func testGivenNameWhenGetHeroesThenMatchSuccess() throws {
		let id = String.randomString()
		let expected = [TransformationModel(id: id, name: "Kaioken", description: "des", photo: nil)]
		
		sut = TransformationTableUseCaseFakeSuccess()
		let expectation = expectation(description: "Heroes transformation success")
		var transformationOutput: [TransformationModel]?
		
		sut.getTransformations(heroId: id) { transformations in
			transformationOutput = transformations
			expectation.fulfill()
		} onError: { error in
			XCTFail("Test throws error")
		}
		
		wait(for: [expectation], timeout: 1)
		
		let transformationOutputResult = try XCTUnwrap(transformationOutput)
		XCTAssertEqual(transformationOutputResult, expected)
	}
 
 func testGivenHeroesWhenGetHeroesThenMatchOnError() throws {
	 let expected = NetworkError.other
	 let expectation = expectation(description: "Transformation error")
	 sut = TransformationTableUseCaseFakeError()
	 var errorOutput: NetworkError?
	 
	 sut.getTransformations(heroId: String.randomString()) { heroes in
		 XCTFail("Test should not Success")
	 } onError: { error in
		 errorOutput = error
		 expectation.fulfill()
	 }
	 
	 wait(for: [expectation], timeout: 1)
	 let errorResult = try XCTUnwrap(errorOutput)
	 XCTAssertEqual(errorResult, expected)
 }
}
