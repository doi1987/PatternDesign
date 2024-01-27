//
//  TransformationTableViewModel.swift
//  AppPetronesDavidOrtegaIglesias
//
//  Created by David Ortega Iglesias on 26/1/24.
//

import Foundation

final class TransformationTableViewModel {
	
	// MARK: - Binding con UI
	var transformationStatusLoad: ((SplashStatusLoad) -> Void)?
	
	// MARK: - Caso de uso
	private let transformationUseCase: TransformationTableUseCaseProtocol
	
	var dataTransformations: [TransformationModel] = []
	private let heroId: String
	
	// MARK: - Inits
	init(heroId: String, transformationUseCase: TransformationTableUseCase = TransformationTableUseCase()) {
		self.heroId = heroId
		self.transformationUseCase = transformationUseCase
	}
	
	// MARK: - Get Transformations
	func loadTransformations() {
		transformationStatusLoad?(.loading)
		
		transformationUseCase.getTransformations(heroId: heroId) { [weak self] transformations in
			DispatchQueue.main.async {
				self?.dataTransformations = transformations
				self?.transformationStatusLoad?(.loaded)
			}
		} onError: { [weak self] networkError in
			self?.transformationStatusLoad?(.error(error: networkError))
		}	
	}
}
