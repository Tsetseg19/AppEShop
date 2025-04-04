import Foundation
import FirebaseAuth

class CartInteractor: CartInteractorProtocol {
    weak var presenter: CartPresenterProtocol?
    var networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func fetchCartItems() {
        guard let userId = Auth.auth().currentUser?.uid else {
            presenter?.didFailToFetchCartItems(error: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not logged in"]))
            return
        }
        
        networkService.fetchCartItems(userId: userId) { [weak self] result in
            switch result {
            case .success(let items):
                // Fetch product details for each cart item
                let group = DispatchGroup()
                var viewModels: [CartItemViewModel] = []
                var hasError = false
                
                for item in items {
                    group.enter()
                    self?.networkService.fetchProduct(id: item.productId) { result in
                        switch result {
                        case .success(let product):
                            let viewModel = CartItemViewModel(
                                product: product,
                                quantity: item.quantity
                            )
                            viewModels.append(viewModel)
                        case .failure:
                            hasError = true
                        }
                        group.leave()
                    }
                }
                
                group.notify(queue: .main) {
                    if hasError {
                        self?.presenter?.didFailToFetchCartItems(error: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch product details"]))
                    } else {
                        self?.presenter?.didFetchCartItems(viewModels)
                    }
                }
            case .failure(let error):
                self?.presenter?.didFailToFetchCartItems(error: error)
            }
        }
    }
    
    func updateCartItemQuantity(productId: String, newQuantity: Int) {
        guard let userId = Auth.auth().currentUser?.uid else {
            presenter?.didFailToUpdateCartItemQuantity(error: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not logged in"]))
            return
        }
        
        networkService.updateCartItemQuantity(userId: userId, productId: productId, quantity: newQuantity) { [weak self] result in
            switch result {
            case .success:
                self?.presenter?.didUpdateCartItemQuantity(productId: productId, newQuantity: newQuantity)
            case .failure(let error):
                self?.presenter?.didFailToUpdateCartItemQuantity(error: error)
            }
        }
    }
    
    func removeCartItem(productId: String) {
        guard let userId = Auth.auth().currentUser?.uid else {
            presenter?.didFailToRemoveCartItem(error: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not logged in"]))
            return
        }
        
        networkService.removeCartItem(userId: userId, productId: productId) { [weak self] result in
            switch result {
            case .success:
                self?.presenter?.didRemoveCartItem(productId: productId)
            case .failure(let error):
                self?.presenter?.didFailToRemoveCartItem(error: error)
            }
        }
    }
} 