import Foundation
import FirebaseAuth

class CheckoutInteractor: CheckoutInteractorProtocol {
    weak var presenter: CheckoutPresenterProtocol?
    var networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func fetchCartTotal(completion: @escaping (Result<Double, Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])))
            return
        }
        
        networkService.fetchCartItems(userId: userId) { [weak self] result in
            switch result {
            case .success(let items):
                let group = DispatchGroup()
                var total = 0.0
                var hasError = false
                
                for item in items {
                    group.enter()
                    self?.networkService.fetchProduct(id: item.productId) { result in
                        switch result {
                        case .success(let product):
                            total += product.price * Double(item.quantity)
                        case .failure:
                            hasError = true
                        }
                        group.leave()
                    }
                }
                
                group.notify(queue: .main) {
                    if hasError {
                        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch product details"])))
                    } else {
                        completion(.success(total))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func completeCheckout(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])))
            return
        }
        
        // First fetch all cart items
        networkService.fetchCartItems(userId: userId) { [weak self] result in
            switch result {
            case .success(let items):
                // Remove each item from the cart
                let group = DispatchGroup()
                var hasError = false
                
                for item in items {
                    group.enter()
                    self?.networkService.removeCartItem(userId: userId, productId: item.productId) { result in
                        if case .failure = result {
                            hasError = true
                        }
                        group.leave()
                    }
                }
                
                group.notify(queue: .main) {
                    if hasError {
                        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to clear cart"])))
                    } else {
                        completion(.success(()))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
} 