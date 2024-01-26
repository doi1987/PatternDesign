//
//  SplashViewModel.swift
//  AppPetronesDavidOrtegaIglesias
//
//  Created by David Ortega Iglesias on 22/1/24.
//

import Foundation

final class SplashViewModel {
	//binding con UI
	var modelStatusLoad: ((SplashStatusLoad) -> Void)?
	
	//Funcion Simular Carga Datos
	func simulationLoadData() {
		//Variable estado --> Estoy cargando
		modelStatusLoad?(.loading)
		DispatchQueue.main.asyncAfter(deadline: .now() + 3){ [weak self] in
			//Variable estado --> Ya me he cargado
			self?.modelStatusLoad?(.loaded)
		}
	}
}
