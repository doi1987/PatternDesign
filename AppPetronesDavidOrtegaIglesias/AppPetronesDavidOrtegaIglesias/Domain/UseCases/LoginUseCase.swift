//
//  LoginUseCase.swift
//  AppPetronesDavidOrtegaIglesias
//
//  Created by David Ortega Iglesias on 22/1/24.
//

import Foundation
	// MARK: - Protocolo login use case
protocol LoginUseCaseProtocol {
	func login(
		user: String, 
		password: String, 
		onSuccess: @escaping (String?) -> Void,
		onError: @escaping (NetworkError) -> Void)
}

	// MARK: - Clase Login UseCase
final class LoginUseCase: LoginUseCaseProtocol {
	func login(
		user: String, 
		password: String, 
		onSuccess: @escaping (String?) -> Void,
		onError: @escaping (NetworkError) -> Void)
	{
		// Comprobar la url
		guard let url = URL(string: "\(EndPoints.url.rawValue)\(EndPoints.login.rawValue)") else {
			onError(.malformedURL)
			return
		}
		
		//Codificar datos
		//user: password
		let loginString = String(format: "%@:%@", user, password)
		guard let loginData = loginString.data(using: .utf8) else {
			onError(.dataFormatting)
			return
		}
		let base64LoginString = loginData.base64EncodedString()
		// Crear request
		var urlRequest = URLRequest(url: url)
		urlRequest.httpMethod = HTTPMethods.post
		urlRequest.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
		
		// Data Task
		let task = URLSession.shared.dataTask(with: urlRequest) { data, response , error in
			//CHeck error
			guard error == nil else {
				onError(.other)
				return
			}
			//Check Data
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
			
			// Transformar el dato para tener el token
			guard let token = String(data: data, encoding: .utf8) else {
				onError(.tokenFormatError)
				return
			}
			UserDefaultsHelper.save(token: token)
			onSuccess(token)
		}
		task.resume()
	}
}

// MARK: - Login Use Case Fake Success
final class LoginUseCaseFakeSuccess: LoginUseCaseProtocol {
	func login(user: String, password: String, onSuccess: @escaping (String?) -> Void, onError: @escaping (NetworkError) -> Void) {
		DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
			let token = "123456"
			onSuccess(token)
		}
	}
}

// MARK: - Login Use Case Fake Error
final class LoginUseCaseFakeError:LoginUseCaseProtocol {
	func login(user: String, password: String, onSuccess: @escaping (String?) -> Void, onError: @escaping (NetworkError) -> Void) {
		DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
			onError(.tokenFormatError)
		}
	}
}
