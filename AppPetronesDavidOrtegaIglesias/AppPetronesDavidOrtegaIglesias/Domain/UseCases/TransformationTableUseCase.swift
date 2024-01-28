//
//  TransformationTableUseCase.swift
//  AppPetronesDavidOrtegaIglesias
//
//  Created by David Ortega Iglesias on 26/1/24.
//

import Foundation

protocol TransformationTableUseCaseProtocol {
	func getTransformations(heroId: String, onSuccess: @escaping ([TransformationModel]) -> Void, onError: @escaping (NetworkError) -> Void)
}

final class TransformationTableUseCase: TransformationTableUseCaseProtocol {
	private let networkAPI: APINetworkProtocol
	
	init(networkAPI: NetworkAPI = NetworkAPI()) {
		self.networkAPI = networkAPI
	}
	
	func getTransformations(heroId: String, onSuccess: @escaping ([TransformationModel]) -> Void, onError: @escaping (NetworkError) -> Void) {
		
		struct TransformationRequest: Encodable {
			let name: String
			let id: String
		}
		
		let bodyRequest = TransformationRequest(name: "id", id: heroId)

		networkAPI.fetchData(endpoint: EndPoints.transformation.rawValue, body: bodyRequest, type: [TransformationModel].self, onSuccess: onSuccess, onError: onError)
	}
}

// MARK: - Fake Succes
final class TransformationTableUseCaseFakeSuccess: TransformationTableUseCaseProtocol {	
	func getTransformations(heroId: String, onSuccess: @escaping ([TransformationModel]) -> Void, onError: @escaping (NetworkError) -> Void) {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			let transformation = [TransformationModel(id: heroId, name: "Kaioken", description: "des", photo: nil)]
			onSuccess(transformation)
		}
	}
}

// MARK: - Fake Error

final class TransformationTableUseCaseFakeError: TransformationTableUseCaseProtocol {
	func getTransformations(heroId: String, onSuccess: @escaping ([TransformationModel]) -> Void, onError: @escaping (NetworkError) -> Void)  {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			onError(.other)
		}
	}
}
