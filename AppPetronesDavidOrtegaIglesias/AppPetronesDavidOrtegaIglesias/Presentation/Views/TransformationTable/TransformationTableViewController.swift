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
	
	@IBOutlet weak var loadingView: UIView!
	
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
		tableView.register(UINib(nibName: TransformationTableViewCell.nibName, bundle: nil).self, forCellReuseIdentifier: TransformationTableViewCell.identifier)
		transformationTableViewModel.loadTransformations()
		setObservers()
	}
	
	// MARK: - Conectar Variable Estado ViewModel
	func setObservers() {
		transformationTableViewModel.transformationStatusLoad = { [weak self] status in
			switch status {
			case .loading:
				self?.loadingView.isHidden = false			case .loaded:
				self?.loadingView.isHidden = true
				self?.tableView.reloadData()
			case .error(let error):
				self?.loadingView.isHidden = true
			case .none:
				print("Home None")
			}
		}
	}
	
}

// MARK: - Delegate
extension TransformationTableViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let nextVM = TransformationDetailViewModel(transformationDetail: transformationTableViewModel.dataTransformations[indexPath.row])
		let nextVC = TransformationDetailViewController(transformationDetailViewModel: nextVM)
			navigationController?.show(nextVC, sender: nil)
	}
}

// MARK: - Datasource
extension TransformationTableViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return transformationTableViewModel.dataTransformations.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: TransformationTableViewCell.identifier) as? TransformationTableViewCell else { return UITableViewCell()}
		cell.configure(with: transformationTableViewModel.dataTransformations[indexPath.row])
		return cell
	}
} 
