import Foundation

class CheckoutPresenter: CheckoutPresenterProtocol {
    weak var view: CheckoutViewProtocol?
    var interactor: CheckoutInteractorProtocol?
    var router: CheckoutRouterProtocol?
    
    func viewDidLoad() {
        view?.showLoading()
        interactor?.fetchCartTotal(completion: { [weak self] result in
            switch result {
            case .success(let total):
                self?.didFetchCartTotal(total)
            case .failure(let error):
                self?.didFailToFetchCartTotal(error: error)
            }
        })
    }
    
    // MARK: - Interactor Callbacks
    func didFetchCartTotal(_ total: Double) {
        view?.hideLoading()
        view?.updateTotal(total)
    }
    
    func didFailToFetchCartTotal(error: Error) {
        view?.hideLoading()
        view?.showError(error.localizedDescription)
    }
    
    func didCompleteCheckout() {
        view?.hideLoading()
        view?.showSuccess("Order placed successfully!")
    }
    
    func didFailToCompleteCheckout(error: Error) {
        view?.hideLoading()
        view?.showError(error.localizedDescription)
    }
    
    // MARK: - User Actions
    func didTapCompleteCheckout() {
        view?.showLoading()
        interactor?.completeCheckout(completion: { [weak self] result in
            switch result {
            case .success:
                self?.didCompleteCheckout()
            case .failure(let error):
                self?.didFailToCompleteCheckout(error: error)
            }
        })
    }
    
    func didTapContinueShopping() {
        router?.navigateToProducts()
    }
} 