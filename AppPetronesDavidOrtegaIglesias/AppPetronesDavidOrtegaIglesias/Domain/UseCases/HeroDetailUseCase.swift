//
//  HeroDetailUseCases.swift
//  AppPetronesDavidOrtegaIglesias
//
//  Created by David Ortega Iglesias on 24/1/24.
//

import Foundation

// MARK: - Protocolo Hero
protocol  HeroDetailUseCaseProtocol {
	func getTransformations(heroId: String, onSuccess: @escaping ([TransformationModel]) -> Void, onError: @escaping (NetworkError) -> Void)
	func getHeroDetail(name: String, onSuccess: @escaping (HeroModel) -> Void, onError: @escaping (NetworkError) -> Void)

}

// MARK: - Clase Hero Use Case
final class HeroDetailUseCase: HeroDetailUseCaseProtocol {
	func getHeroDetail(name: String, onSuccess: @escaping (HeroModel) -> Void, onError: @escaping (NetworkError) -> Void) {
		
		// Comprobar url
		guard let url = URL(string: "\(EndPoints.url.rawValue)\(EndPoints.allHeros.rawValue)") else {
			onError(.malformedURL)
			return
		}
		
		// Check token
		guard let token = UserDefaultsHelper.getToken() else {
			onError(.tokenFormatError)
			return
		}
		
		// Crear request
		var urlRequest = URLRequest(url: url)
		urlRequest.httpMethod = HTTPMethods.post
		urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
		urlRequest.setValue(HTTPMethods.contentType, forHTTPHeaderField: "Content-Type")
		
		// Body
		struct HeroRequest: Encodable {
			let name: String
		}
		
		let heroRequest = HeroRequest(name: name)
		urlRequest.httpBody = try? JSONEncoder().encode(heroRequest)
		
		// ****** Crear generico para no ser repetitivo
		// Task
		let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
			// Check error
			guard error == nil else {
				onError(.other)
				return
			}
			
			// Check data
			guard let data = data else {
				onError(.noData)
				return
			}
			
			// Check response
			guard let httpResponse = (response as? HTTPURLResponse),
				  httpResponse.statusCode == HTTPResponseCodes.SUCCESS else {
				onError(.errorCode((response as? HTTPURLResponse)?.statusCode))
				return
			}
			
			guard let heroResponse = try? JSONDecoder().decode(HeroModel.self, from: data) else {
				onError(.decoding)
				return
			}
			
			onSuccess(heroResponse)
			
		}
		task.resume()
	}
	
	func getTransformations(heroId: String, onSuccess: @escaping ([TransformationModel]) -> Void, onError: @escaping (NetworkError) -> Void) {
		
		// Comprobar URL
		guard let url = URL(string: "\(EndPoints.url.rawValue)\(EndPoints.transformation.rawValue)") else {
			onError(.malformedURL)
			return
		}
		
		// Check token
		guard let token = UserDefaultsHelper.getToken() else {
			onError(.tokenFormatError)
			return
		}
		
		// Creamos una request
		var urlRequest = URLRequest(url: url)
		urlRequest.httpMethod = HTTPMethods.post
		urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
		// **** Que es esto
		urlRequest.setValue(HTTPMethods.contentType, forHTTPHeaderField: "Content-Type")
		
		// Body
		struct TransformationRequest: Encodable {
			let name: String
			let id: String
		}
		
		let transformationRequest = TransformationRequest(name: "id", id: heroId)
		urlRequest.httpBody = try? JSONEncoder().encode(transformationRequest)
		
		// Task
		let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
			// Check error
			guard error == nil else {
				onError(.other)
				return
			}
			
			// Check Data
			guard let data = data else {
				onError(.noData)
				return
			}
			
			// Check response
			guard let httpResponse = (response as? HTTPURLResponse), 
					httpResponse.statusCode == HTTPResponseCodes.SUCCESS else {
				onError(.errorCode((response as? HTTPURLResponse)?.statusCode))
				return
			}
			
			guard let transformationResponse = try? JSONDecoder().decode([TransformationModel].self, from: data) else {
				onError(.decoding)
				return
			}
			
			onSuccess(transformationResponse)
		}
		task.resume()
	}
}

// MARK: - Fake Success
final class HeroDetailUseCaseFakeSuccess: HeroDetailUseCaseProtocol {
	func getHeroDetail(name: String, onSuccess: @escaping (HeroModel) -> Void, onError: @escaping (NetworkError) -> Void) {
		
	}
	
	func getTransformations(heroId: String, onSuccess: @escaping ([TransformationModel]) -> Void, onError: @escaping (NetworkError) -> Void) {
		DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
			let transformation = [TransformationModel(id: "1", name: "Ozaru", description: "Blablabla", photo: ""),
			TransformationModel(id: "2", name: "Super", description: "Bla2", photo: "")]
			
			onSuccess(transformation)
		}
	}
}
// MARK: - Fake Error
final class HeroDetailUseCaseFakeError: HeroDetailUseCaseProtocol {
	func getHeroDetail(name: String, onSuccess: @escaping (HeroModel) -> Void, onError: @escaping (NetworkError) -> Void) {
		
	}
	
	func getTransformations(heroId: String, onSuccess: @escaping ([TransformationModel]) -> Void, onError: @escaping (NetworkError) -> Void) {
		DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
			onError(.noData)
		}
	}
}

