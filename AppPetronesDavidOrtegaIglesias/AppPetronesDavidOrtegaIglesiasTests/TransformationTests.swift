//
//  TransformationTests.swift
//  AppPetronesDavidOrtegaIglesiasTests
//
//  Created by David Ortega Iglesias on 28/1/24.
//

import XCTest
@testable import AppPetronesDavidOrtegaIglesias

final class TransformationTests: XCTestCase {
	
	func testGivenSameTransformationsWhenCompareThenMatch() throws {
		let firstTransformation: TransformationModel = .init(id: "1", name: "Ozaru", description: "des", photo: "")
		let secondTransformation: TransformationModel = .init(id: "1", name: "Ozaru", description: "des", photo: "")
		XCTAssertEqual(firstTransformation, secondTransformation)
	}
	
	func testGivenDifferentTransformationsWhenCompareThenMatch() {
		let firstTransformation: TransformationModel = .init(id: "2", name: "Kaioken", description: "desc", photo: "")
		let secondTransformation: TransformationModel = .init(id: "1", name: "Ozaru", description: "des", photo: "")
		XCTAssertNotEqual(firstTransformation, secondTransformation)
	}
	
	func testGivenTransformationWhenCompareThenHaveData() throws {
		let transformation = TransformationModel(id: "1", name: "Ozaru", description: "des", photo: "")
		
		XCTAssertNotNil(transformation)
		XCTAssertEqual(transformation.name, "Ozaru")
		XCTAssertEqual(transformation.id, "1")
		XCTAssertEqual(transformation.description, "des")
	}
	
	func testGivenTransformationsWhenSortThenMatch() throws {
		let firstTransformation: TransformationModel = .init(id: "1", name: "1. Kaioken", description: "desc", photo: "")
		let secondTransformation: TransformationModel = .init(id: "2", name: "2. Ozaru", description: "des", photo: "")
		let thirdTransformation: TransformationModel = .init(id: "10", name: "10. Super", description: "descr", photo: "")
		
		XCTAssertGreaterThan(secondTransformation, firstTransformation)
		XCTAssertGreaterThan(thirdTransformation, firstTransformation)
		XCTAssertLessThan(secondTransformation, thirdTransformation)
	}
}
