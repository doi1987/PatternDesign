//
//  HeroDetailViewModel.swift
//  AppPetronesDavidOrtegaIglesias
//
//  Created by David Ortega Iglesias on 24/1/24.
//

import Foundation

final class HeroDetailViewModel {
	
	// Binding con UI
	var heroDetailStatusLoad: ((SplashStatusLoad) -> Void)?
	
	// Use Case
	let heroDetailUseCase: HeroDetailUseCaseProtocol
	// *******
	private let name: String
	var heroe: HeroModel?
	var dataTransformations: [TransformationModel] = []
	
	// Init
	init(name: String, heroDetailUseCase: HeroDetailUseCaseProtocol = HeroDetailUseCase()) {
		self.name = name
		self.heroDetailUseCase = heroDetailUseCase
	}
	
	func loadDetail() {
		// ******
		heroDetailStatusLoad?(.loading)
		
		heroDetailUseCase.getHeroDetail(name: name) { [weak self] heroe in
			DispatchQueue.main.async {
				self?.heroe = heroe.first
				self?.heroDetailStatusLoad?(.loaded)
			}
		} onError: { [weak self] networkError in
			DispatchQueue.main.async {
				self?.heroDetailStatusLoad?(.error(error: networkError))
			}
		}
	}
	
	// LLamada a getTransformations
	func loadTransformations() {
		heroDetailStatusLoad?(.loading)
		
		heroDetailUseCase.getTransformations(heroId: "") { [weak self] transformations in
			DispatchQueue.main.async {
				self?.dataTransformations = transformations
				self?.heroDetailStatusLoad?(.loaded)
				
			}
		} onError: { networkError in
			DispatchQueue.main.async {
				self.heroDetailStatusLoad?(.error(error: networkError))
			}
		}
	}
}
