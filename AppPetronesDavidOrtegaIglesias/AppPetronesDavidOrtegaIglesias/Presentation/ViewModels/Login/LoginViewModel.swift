//
//  LoginViewModel.swift
//  AppPetronesDavidOrtegaIglesias
//
//  Created by David Ortega Iglesias on 22/1/24.
//

import Foundation

final class LoginViewModel {
	// MARK: - Binding con UI
	var loginViewState: ((LoginStatusLoad) -> Void)?
	
	private let loginUseCase: LoginUseCaseProtocol
	
	// MARK: - Inits
	init(loginUseCase: LoginUseCaseProtocol = LoginUseCase()) {
		self.loginUseCase = loginUseCase
	}
	
	// MARK: - Metodo login
	func onLoginButton(email: String?, password: String?) {
		loginViewState?(.loading(true))
		
		// Check del email y password
		guard let email = email, isValid(email: email) else {
			loginViewState?(.loading(false))
			loginViewState?(.showErrorEmail("Error en el email"))
			return
		}
		
		guard let password = password, isValid(password: password) else {
			loginViewState?(.loading(false))
			loginViewState?(.showErrorPassword("Error en el password"))
			return
		}
		
		doLoginWith(email: email, password: password)
	}
	
	// Check email
	private func isValid(email: String) -> Bool {
		email.isEmpty == false && email.contains("@")
	}
	
	// Check password
	private func isValid(password: String) -> Bool {
		password.isEmpty == false && password.count >= 4
	}
	
	private func doLoginWith(email: String, password: String) {
		loginUseCase.login(user: email, password: password) { [weak self] token in
			DispatchQueue.main.async {
				self?.loginViewState?(.loaded)
			}
			
		} onError: { [weak self] networkError in
			DispatchQueue.main.async {
				var errorMessage = "Error Desconocido"
				switch networkError {
				case .malformedURL:
					errorMessage = "Malformed URL"
				case .dataFormatting:
					errorMessage = "Data Formatting"
				case .other:
					errorMessage = "other"
				case .noData:
					errorMessage = "noData"
				case .errorCode(let error):
					errorMessage = "ErrorCode \(error?.description ?? "Unknown")"
				case .tokenFormatError:
					errorMessage = "token Format Error"
				case .decoding:
					errorMessage = "decoding"
				}
				self?.loginViewState?(.errorNetwork(errorMessage))
			}
		}
	}
}

