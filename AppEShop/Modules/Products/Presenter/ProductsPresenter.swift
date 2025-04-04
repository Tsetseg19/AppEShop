import Foundation

class ProductsPresenter: ProductsPresenterProtocol {
    weak var view: ProductsViewProtocol?
    var interactor: ProductsInteractorProtocol?
    var router: ProductsRouterProtocol?
    
    func viewDidLoad() {
        view?.showLoading()
        interactor?.fetchProducts(completion: { [weak self] result in
            switch result {
            case .success(let products):
                self?.didFetchProducts(products: products)
            case .failure(let error):
                self?.didFailToFetchProducts(error: error)
            }
        })
    }
    
    // MARK: - Interactor Callbacks
    func didFetchProducts(products: [Product]) {
        view?.hideLoading()
        view?.updateProductsList(products)
    }
    
    func didFailToFetchProducts(error: NetworkError) {
        view?.hideLoading()
        view?.showError(error.localizedDescription)
    }
    
    // MARK: - User Actions
    func didSelectProduct(_ product: Product) {
        router?.showProductDetail(product: product)
    }
    
    func didTapCart() {
        router?.showCart()
    }
    
    func didTapAddToCart(_ product: Product) {
        view?.showLoading()
        interactor?.addToCart(product: product, completion: { [weak self] result in
            switch result {
            case .success:
                self?.view?.hideLoading()
                self?.view?.showSuccess("Product added to cart successfully")
            case .failure(let error):
                self?.didFailToAddToCart(error: error)
            }
        })
    }
    
    func didFailToAddToCart(error: NetworkError) {
        view?.showError("Failed to add to cart: \(error.localizedDescription)")
    }
} 