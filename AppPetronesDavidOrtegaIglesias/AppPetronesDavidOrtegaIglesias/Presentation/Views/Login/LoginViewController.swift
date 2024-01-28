//
//  LoginViewController.swift
//  AppPetronesDavidOrtegaIglesias
//
//  Created by David Ortega Iglesias on 22/1/24.
//

import UIKit
enum TextFieldIdentifier: Int {
	case email = 0
	case password = 1
}

class LoginViewController: UIViewController {
	// MARK: - Outlets
	
	@IBOutlet weak var emailTextField: UITextField!	
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var errorEmail: UILabel!
	@IBOutlet weak var errorPassword: UILabel!
	@IBOutlet weak var loadingView: UIView!
	
	private var viewModel: LoginViewModel
	
	// MARK: - Inits
	init(viewModel: LoginViewModel = LoginViewModel()) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	// MARK: - Lifecycle
	override func viewDidLoad() {
        super.viewDidLoad()
		emailTextField.addTarget(self, action: #selector(validEmail(_:)), for: .editingChanged)
		passwordTextField.addTarget(self, action: #selector(validPassword(_:)), for: .editingChanged)
		setLoginData()
		setObservers()
    }
	
	// MARK: - Action
	@IBAction func onLoginButtonTap(_ sender: Any) {
		viewModel.onLoginButton(email: emailTextField.text, password: passwordTextField.text)
	}
	@objc func validEmail(_ sender: UITextField) {
		guard let text = sender.text else { return }

		errorEmail.isHidden = viewModel.isValid(email: text)
	}

	@objc func validPassword(_ sender: UITextField) {
		guard let text = sender.text else { return }

		errorPassword.isHidden = viewModel.isValid(password: text)
	}
}

	// MARK: - Extension
extension LoginViewController {
	// Metodo para "escuchar" variable de estado del viewModel
	private func setObservers() {
		viewModel.loginViewState = { [weak self] status in 
			switch status {
				
			case .loading(let isLoading):
				self?.loadingView.isHidden = !isLoading
				
			case .loaded:
				self?.loadingView.isHidden = true
				self?.navigateToHome()
				
			case .showErrorEmail(let error):
				self?.errorEmail.text = error
				self?.errorEmail.isHidden = (error == nil || error?.isEmpty == true)
				
			case .showErrorPassword(let error):
				self?.errorPassword.text = error
				self?.errorPassword.isHidden = (error == nil || error?.isEmpty == true) 
				
			case .errorNetwork(let errorMessage):
				self?.loadingView.isHidden = true
				self?.showAlert(message: errorMessage)
			}
		}
	}
	// MARK: - Navigate
	private func navigateToHome() {
		let nextVM = HomeViewModel(homeUseCase: HomeUseCase())
		let nextVC = HomeTableViewController(homeViewModel: nextVM)
		navigationController?.setViewControllers([nextVC], animated: true)
	}
	
	// MARK: - Alert
	private func showAlert(message: String) {
		let alertController = UIAlertController(
			title: "ERROR NETWORK", 
			message: message, 
			preferredStyle: .alert)
		let okAction = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
		alertController.addAction(okAction)
		present(alertController, animated: true, completion: nil)
	}
}

#if DEBUG
private extension LoginViewController {
	func setLoginData() {
		emailTextField.text = "davidortegaiglesias@gmail.com"
		passwordTextField.text = "abcdef"
	}
}
#endif

