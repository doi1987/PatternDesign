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

