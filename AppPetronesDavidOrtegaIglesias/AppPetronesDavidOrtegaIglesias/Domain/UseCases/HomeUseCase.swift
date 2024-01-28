//
//  HomeUseCase.swift
//  AppPetronesDavidOrtegaIglesias
//
//  Created by David Ortega Iglesias on 23/1/24.
//

import Foundation

	// MARK: - Protocolo Home
protocol HomeUseCaseProtocol {
	func getHeroes(onSuccess: @escaping ([HeroModel]) -> Void, onError: @escaping (NetworkError) -> Void)
}
	
	// MARK: - CLase homeUseCase
final class HomeUseCase: HomeUseCaseProtocol {
	private let networkAPI: APINetworkProtocol
	
	init(networkAPI: NetworkAPI = NetworkAPI()) {
		self.networkAPI = networkAPI
	}
	
	func getHeroes(onSuccess: @escaping ([HeroModel]) -> Void, onError: @escaping (NetworkError) -> Void) {
		
		struct HeroRequest: Encodable {
			let name: String
		}
		
		let bodyRequest = HeroRequest(name: "")
		
		networkAPI.fetchData(endpoint: EndPoints.allHeros.rawValue, body: bodyRequest, type: [HeroModel].self, onSuccess: onSuccess, onError: onError)
	}
}

// MARK: - Fake Succes
final class HomeUseCaseFakeSuccess: HomeUseCaseProtocol {
	func getHeroes(onSuccess: @escaping ([HeroModel]) -> Void, onError: @escaping (NetworkError) -> Void) {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			let heroes = [HeroModel(id: "1", name: "Diego", description: "Superman", photo: "", favorite: true) ,
						  HeroModel(id: "2", name: "Alejandro", description: "Spiderman", photo: "", favorite: false),
						  HeroModel(id: "3", name: "Rocio", description: "Super Woman", photo: "", favorite: true)]
			onSuccess(heroes)
		}
	}
}

// MARK: - Fake Error

final class HomeUseCaseFakeError: HomeUseCaseProtocol {
	func getHeroes(onSuccess: @escaping ([HeroModel]) -> Void, onError: @escaping (NetworkError) -> Void) {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			onError(.noData)
		}
	}
}
