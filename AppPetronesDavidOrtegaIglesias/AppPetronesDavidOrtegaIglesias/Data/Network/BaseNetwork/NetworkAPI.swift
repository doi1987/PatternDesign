//
//  NetworkAPI.swift
//  AppPetronesDavidOrtegaIglesias
//
//  Created by David Ortega Iglesias on 28/1/24.
//

import Foundation

protocol APINetworkProtocol {
	func fetchData<T: Decodable>(endpoint: String, body: Encodable, type: T.Type, onSuccess: @escaping (T) -> Void, onError: @escaping (NetworkError) -> Void)
}

class NetworkAPI: APINetworkProtocol {	
	func fetchData<T: Decodable>(endpoint: String, body: Encodable, type: T.Type, onSuccess: @escaping (T) -> Void, onError: @escaping (NetworkError) -> Void) {
		// Comprobar URL
		guard let url = URL(string: "\(EndPoints.url.rawValue)\(endpoint)") else {
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
		urlRequest.setValue(HTTPMethods.contentType, forHTTPHeaderField: "Content-Type")
		
		urlRequest.httpBody = try? JSONEncoder().encode(body)
		
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
			
			guard let response = try? JSONDecoder().decode(T.self, from: data) else {
				onError(.decoding)
				return
			}
			
			onSuccess(response)
		}
		task.resume()
	}
}
