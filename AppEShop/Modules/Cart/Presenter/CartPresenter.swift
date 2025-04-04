import Foundation

class CartPresenter: CartPresenterProtocol {
    weak var view: CartViewProtocol?
    var interactor: CartInteractorProtocol?
    var router: CartRouterProtocol?
    
    func viewDidLoad() {
        view?.showLoading()
        interactor?.fetchCartItems()
    }
    
    // MARK: - Interactor Callbacks
    func didFetchCartItems(_ items: [CartItemViewModel]) {
        view?.hideLoading()
        view?.updateCartItems(items)
    }
    
    func didFailToFetchCartItems(error: Error) {
        view?.hideLoading()
        view?.showError(error.localizedDescription)
    }
    
    func didUpdateCartItemQuantity(productId: String, newQuantity: Int) {
        view?.hideLoading()
        // Refresh cart items after update
        interactor?.fetchCartItems()
    }
    
    func didFailToUpdateCartItemQuantity(error: Error) {
        view?.hideLoading()
        view?.showError(error.localizedDescription)
    }
    
    func didRemoveCartItem(productId: String) {
        view?.hideLoading()
        // Refresh cart items after removal
        interactor?.fetchCartItems()
    }
    
    func didFailToRemoveCartItem(error: Error) {
        view?.hideLoading()
        view?.showError(error.localizedDescription)
    }
    
    // MARK: - User Actions
    func didTapUpdateQuantity(productId: String, newQuantity: Int) {
        view?.showLoading()
        interactor?.updateCartItemQuantity(productId: productId, newQuantity: newQuantity)
    }
    
    func didTapRemoveItem(productId: String) {
        view?.showLoading()
        interactor?.removeCartItem(productId: productId)
    }
    
    func didTapCheckout() {
        router?.showCheckout()
    }
} 

