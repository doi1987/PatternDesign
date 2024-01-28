//
//  TransformationDetailUseCase.swift
//  AppPetronesDavidOrtegaIglesias
//
//  Created by David Ortega Iglesias on 27/1/24.
//

import Foundation

// MARK: - Protcol
protocol TransformationDetailUseCaseProtocol {
	func getTransformationDetail(id: String, onSuccess: @escaping ([TransformationModel]) -> Void, onError: @escaping (NetworkError) -> Void)
}

// MARK: - Clase transformation Use Case
final class TransformationDetailUseCase: TransformationDetailUseCaseProtocol {
	
	func getTransformationDetail(id: String, onSuccess: @escaping ([TransformationModel]) -> Void, onError: @escaping (NetworkError) -> Void) {
		
		// Comprobar url
		guard let url = URL(string: "\(EndPoints.url.rawValue)\(EndPoints.transformation.rawValue)") else {
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
		struct TransformationRequest: Encodable {
			let id: String
		}
		
		let transformationRequest = TransformationRequest(id: id)
		urlRequest.httpBody = try? JSONEncoder().encode(transformationRequest)
		
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
final class TransformationDetailUseCaseFakeSuccess: TransformationDetailUseCaseProtocol {
	func getTransformationDetail(id: String, onSuccess: @escaping ([TransformationModel]) -> Void, onError: @escaping (NetworkError) -> Void) {
		DispatchQueue.main.asyncAfter(deadline: .now() + 3){
			let transformation = [TransformationModel(id: "1", name: "Ozaru", description: "desc", photo: ""), 
			TransformationModel(id: "2", name: "KaioKen", description: "des", photo: ""),
			TransformationModel(id: "3", name: "Super", description: "descr", photo: "")]
			onSuccess(transformation)
		}
	}
}

// MARK: - Fake Error
final class TransformationDetailUseCaseFakeError: TransformationDetailUseCaseProtocol {
	func getTransformationDetail(id: String, onSuccess: @escaping ([TransformationModel]) -> Void, onError: @escaping (NetworkError) -> Void) {
		DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
			onError(.noData)
		}
	}
}
