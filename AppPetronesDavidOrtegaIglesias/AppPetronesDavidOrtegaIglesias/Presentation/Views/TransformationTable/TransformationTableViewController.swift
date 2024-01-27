//
//  TransformationTableViewController.swift
//  AppPetronesDavidOrtegaIglesias
//
//  Created by David Ortega Iglesias on 26/1/24.
//

import UIKit

class TransformationTableViewController: UIViewController {
	
	// MARK: - Outlet
	@IBOutlet weak var tableView: UITableView!
	
	// MARK: - Model
	private var transformationTableViewModel: TransformationTableViewModel
	
	// MARK: - Init
	init(transformationTableViewModel: TransformationTableViewModel) {
		self.transformationTableViewModel = transformationTableViewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.delegate = self
		tableView.dataSource = self
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TransformationCell")
		transformationTableViewModel.loadTransformations()
		setObservers()
	}
	
	// MARK: - Conectar Variable Estado ViewModel
	func setObservers() {
		transformationTableViewModel.transformationStatusLoad = { [weak self] status in
			switch status {
			case .loading:
				print("Home Loading")
			case .loaded:
				self?.tableView.reloadData()
			case .error(let error):
				print(error)
			case .none:
				print("Home None")
			}
		}
	}
	
}

// MARK: - Delegate
extension TransformationTableViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		// TODO: Navegar al detail
	}
}

// MARK: - Datasource
extension TransformationTableViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return transformationTableViewModel.dataTransformations.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "TransformationCell", for: indexPath)
		cell.textLabel?.text = transformationTableViewModel.dataTransformations[indexPath.row].name
		return cell
	}
} 
