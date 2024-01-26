//
//  HomeTableViewController.swift
//  AppPetronesDavidOrtegaIglesias
//
//  Created by David Ortega Iglesias on 22/1/24.
//

import UIKit

class HomeTableViewController: UIViewController {

	// MARK: - Outlets
	@IBOutlet weak var tableViewOutlet: UITableView!
	
	// MARK: - View Model
	private var homeViewModel: HomeViewModel
	
	// MARK: - Inits
	init(homeViewModel: HomeViewModel = HomeViewModel()) {
		self.homeViewModel = homeViewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()	
		tableViewOutlet.delegate = self
		tableViewOutlet.dataSource = self
		tableViewOutlet.register(UITableViewCell.self, forCellReuseIdentifier: "HomeCell")
		homeViewModel.loadHeroes()
		setObservers()
    }
	
	// MARK: - Conectar Variable Estado ViewModel
	private func setObservers(){
		homeViewModel.homeStatusLoad = { [weak self] status in
			switch status {
			case .loading:
				// ******* mostrar imagen custom (placeholder)
				print("Home Loading")
			case .loaded:
				self?.tableViewOutlet.reloadData()
			case .error(let error):
				print(error)
			case .none:
				print("Home None")
			}
		}
	}
}

// MARK: - Extension Delegate
extension HomeTableViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		// TODO: - Navegar al detalle
		let nextVM = HeroDetailViewModel(name: homeViewModel.dataHeroes[indexPath.row].name, heroDetailUseCase: HeroDetailUseCase())
		let nextVC = HeroDetailViewController(heroDetailViewModel: nextVM)
			navigationController?.show(nextVC, sender: nil)
	}
}

// MARK: _ Extension DataSource
extension HomeTableViewController: UITableViewDataSource {
	// Numero de filas por seccion
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return homeViewModel.dataHeroes.count
	}
	
	// Formato de la celda
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableViewOutlet.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath)
		cell.textLabel?.text = homeViewModel.dataHeroes[indexPath.row].name
		return cell
	}
}
