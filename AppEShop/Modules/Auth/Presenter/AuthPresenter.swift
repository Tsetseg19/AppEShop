import Foundation

class AuthPresenter: AuthPresenterProtocol {
    weak var view: AuthViewProtocol?
    var interactor: AuthInteractorProtocol?
    var router: AuthRouterProtocol?
    
    func viewDidLoad() {
        if let currentUser = interactor?.getCurrentUser() {
            router?.navigateToHome()
        }
    }
    
    // MARK: - User Actions
    func didTapSignUp(email: String, password: String, name: String) {
        view?.showLoading()
        interactor?.signUp(email: email, password: password, name: name) { [weak self] result in
            self?.view?.hideLoading()
            switch result {
            case .success:
                self?.router?.navigateToHome()
            case .failure(let error):
                self?.view?.showError(error.localizedDescription)
            }
        }
    }
    
    func didTapLogin(email: String, password: String) {
        view?.showLoading()
        interactor?.login(email: email, password: password) { [weak self] result in
            self?.view?.hideLoading()
            switch result {
            case .success:
                self?.router?.navigateToHome()
            case .failure(let error):
                self?.view?.showError(error.localizedDescription)
            }
        }
    }
    
    func didTapLogout() {
        do {
            try interactor?.logout()
            router?.navigateToLogin()
        } catch {
            view?.showError(error.localizedDescription)
        }
    }
    
    // MARK: - Navigation Actions
    func didTapNavigateToLogin() {
        router?.navigateToLogin()
    }
    
    func didTapNavigateToSignUp() {
        router?.navigateToSignUp()
    }
    
    // MARK: - Interactor Callbacks
    func didSignUpSuccessfully() {
        view?.hideLoading()
        router?.navigateToHome()
    }
    
    func didLoginSuccessfully() {
        view?.hideLoading()
        router?.navigateToHome()
    }
    
    func didLogoutSuccessfully() {
        view?.hideLoading()
        router?.navigateToLogin()
    }
    
    func didFailToSignUp(error: Error) {
        view?.hideLoading()
        view?.showError(error.localizedDescription)
    }
    
    func didFailToLogin(error: Error) {
        view?.hideLoading()
        view?.showError(error.localizedDescription)
    }
    
    func didFailToLogout(error: Error) {
        view?.hideLoading()
        view?.showError(error.localizedDescription)
    }
} 