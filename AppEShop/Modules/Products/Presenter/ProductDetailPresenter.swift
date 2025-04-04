import Foundation

class ProductDetailPresenter: ProductDetailPresenterProtocol {
    weak var view: ProductDetailViewProtocol?
    var interactor: ProductDetailInteractorProtocol?
    var router: ProductDetailRouterProtocol?
    
    func viewDidLoad() {
        // Nothing to do here
    }
    
    // MARK: - User Actions
    func didTapAddToCart(_ product: Product) {
        view?.showLoading()
        interactor?.addToCart(product: product, completion: { [weak self] result in
            switch result {
            case .success:
                self?.didAddToCartSuccessfully()
            case .failure(let error):
                self?.didFailToAddToCart(error: error)
            }
        })
    }
    
    // MARK: - Interactor Callbacks
    func didAddToCartSuccessfully() {
        view?.hideLoading()
        view?.showSuccess("Product added to cart successfully")
    }
    
    func didFailToAddToCart(error: Error) {
        view?.hideLoading()
        view?.showError("Failed to add to cart: \(error.localizedDescription)")
    }
} 