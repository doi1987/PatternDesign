//
//  HeroDetailViewController.swift
//  AppPetronesDavidOrtegaIglesias
//
//  Created by David Ortega Iglesias on 24/1/24.
//

import UIKit

class HeroDetailViewController: UIViewController {
	
	// MARK: - Outlets
	@IBOutlet weak var heroImage: UIImageView!	
	@IBOutlet weak var heroName: UILabel!	
	@IBOutlet weak var heroDescription: UILabel!
	@IBOutlet weak var transformationButton: UIButton!
	
	// MARK: - View Model
	private let heroDetailViewModel: HeroDetailViewModel
	
	// MARK: - Init
	// ******* Valor por defecto
	init(heroDetailViewModel: HeroDetailViewModel) {
		self.heroDetailViewModel = heroDetailViewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		heroDetailViewModel.loadDetail()
		setObservers()
	}
	
	// MARK: - Conectar Variable Estado ViewModel
	private func setObservers(){
		heroDetailViewModel.heroDetailStatusLoad = { [weak self] status in
			switch status {
			case .loading:
				// ******* mostrar imagen custom (placeholder)
				print("Hero Detail Loading")
			case .loaded:
				self?.setupView()
			case .error(let error):
				print(error)
			case .none:
				print("Hero Detail None")
			}
		}
	}
}	

private extension HeroDetailViewController {
	func setupView() {
		heroName.text = heroDetailViewModel.heroe?.name
		heroDescription.text = heroDetailViewModel.heroe?.description
		guard let imageUrlString = heroDetailViewModel.heroe?.photo,
			  let imageURL = URL(string: imageUrlString) else {
			return
		}
		heroImage.setImage(url: imageURL)
	}
}
