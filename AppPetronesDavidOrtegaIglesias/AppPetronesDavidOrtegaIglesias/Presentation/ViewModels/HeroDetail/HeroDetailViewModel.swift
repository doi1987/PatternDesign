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
	
	private let name: String
	var hero: HeroModel?
	var dataTransformations: [TransformationModel] = []
	
	// Init
	init(name: String, heroDetailUseCase: HeroDetailUseCaseProtocol = HeroDetailUseCase()) {
		self.name = name
		self.heroDetailUseCase = heroDetailUseCase
	}
	
	func loadDetail() {
		// ******
		heroDetailStatusLoad?(.loading)
		
		heroDetailUseCase.getHeroDetail(name: name) { [weak self] hero in
			DispatchQueue.main.async {
				guard let hero = hero.first else { 
					self?.heroDetailStatusLoad?(.error(error: .noData))
					return 
				}
				self?.hero = hero
				self?.loadTransformations(heroId: hero.id)
//				self?.heroDetailStatusLoad?(.loaded)
			}
		} onError: { [weak self] networkError in
			DispatchQueue.main.async {
				self?.heroDetailStatusLoad?(.error(error: networkError))
			}
		}
	}
	
	// LLamada a getTransformations
	func loadTransformations(heroId: String) {
		heroDetailUseCase.getTransformations(heroId: heroId) { [weak self] transformations in
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
	
	func getHeroId() -> String? {
		let heroId = hero?.id
		return heroId
	}
}
