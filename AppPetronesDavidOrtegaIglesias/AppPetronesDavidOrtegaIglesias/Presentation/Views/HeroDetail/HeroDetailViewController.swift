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
	private let transformations: [TransformationTableViewModel] = []
	
	// MARK: - Init
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
		transformationButton.isHidden = true
		heroDetailViewModel.loadDetail()
		setObservers()
	}
	
	// MARK: - Action
	@IBAction func didTapTransformationButton(_ sender: Any) {
		guard let heroId = heroDetailViewModel.getHeroId() else { return }
		
		let nextVM = TransformationTableViewModel(heroId: heroId, transformationUseCase: TransformationTableUseCase())
		let nextVC = TransformationTableViewController(transformationTableViewModel: nextVM)
		navigationController?.show(nextVC, sender: nil)
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
		heroName.text = heroDetailViewModel.hero?.name
		heroDescription.text = heroDetailViewModel.hero?.description
		heroImage.image = UIImage(named: "placeholder")
		
		guard let imageUrlString = heroDetailViewModel.hero?.photo,
			  let imageURL = URL(string: imageUrlString) else {
			return
		}
		heroImage.setImage(url: imageURL)		
		transformationButton.isHidden = heroDetailViewModel.dataTransformations.isEmpty
	}
}
