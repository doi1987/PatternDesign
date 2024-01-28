//
//  HeroDetailUseCases.swift
//  AppPetronesDavidOrtegaIglesias
//
//  Created by David Ortega Iglesias on 24/1/24.
//

import Foundation

// MARK: - Protocolo Hero
protocol  HeroDetailUseCaseProtocol {
	func getHeroDetail(name: String, onSuccess: @escaping ([HeroModel]) -> Void, onError: @escaping (NetworkError) -> Void)
}

// MARK: - Clase Hero Use Case
final class HeroDetailUseCase: HeroDetailUseCaseProtocol {	
	private let networkAPI: APINetworkProtocol
	
	init(networkAPI: NetworkAPI = NetworkAPI()) {
		self.networkAPI = networkAPI
	}
	
	func getHeroDetail(name: String, onSuccess: @escaping ([HeroModel]) -> Void, onError: @escaping (NetworkError) -> Void) {
		
		struct HeroRequest: Encodable {
			let name: String
		}
		
		let bodyRequest = HeroRequest(name: name)

		networkAPI.fetchData(endpoint: EndPoints.allHeros.rawValue, body: bodyRequest, type: [HeroModel].self, onSuccess: onSuccess, onError: onError)
	}
}

// MARK: - Fake Succes
final class HeroDetailUseCaseFakeSuccess: HeroDetailUseCaseProtocol {
	func getHeroDetail(name: String, onSuccess: @escaping ([HeroModel]) -> Void, onError: @escaping (NetworkError) -> Void) {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			let hero = [HeroModel(id: "1", name: name, description: "Superman", photo: "", favorite: true)]
			onSuccess(hero)
		}
	}
}

// MARK: - Fake Error

final class HeroDetailUseCaseFakeError: HeroDetailUseCaseProtocol {
	func getHeroDetail(name: String, onSuccess: @escaping ([HeroModel]) -> Void, onError: @escaping (NetworkError) -> Void) {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			onError(.malformedURL)
		}
	}
}
