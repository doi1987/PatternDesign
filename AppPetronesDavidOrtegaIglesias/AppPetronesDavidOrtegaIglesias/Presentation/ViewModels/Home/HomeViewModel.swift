//
//  HomeViewModel.swift
//  AppPetronesDavidOrtegaIglesias
//
//  Created by David Ortega Iglesias on 23/1/24.
//

import Foundation

final class HomeViewModel {
	
	// MARK: - Binding con UI
	var homeStatusLoad: ((SplashStatusLoad) -> Void)?
	
	// case Use
	let homeUseCase: HomeUseCaseProtocol
	
	var dataHeroes: [HeroModel] = []
	
	// MARK: - Init
	init(homeUseCase: HomeUseCaseProtocol = HomeUseCase()) {
		self.homeUseCase = homeUseCase
	}
	
	// MARK: - GetHeroes
	func loadHeroes() {
		homeStatusLoad?(.loading)
		
		homeUseCase.getHeroes { [weak self] heroes in
			DispatchQueue.main.async {
				self?.dataHeroes = heroes
				self?.homeStatusLoad?(.loaded)
			}
		} onError: { [weak self] networkError in
			DispatchQueue.main.async {
				self?.homeStatusLoad?(.error(error: networkError))
			}
		}
	}
}
