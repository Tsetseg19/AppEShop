import Foundation
import FirebaseAuth

class ProductDetailInteractor: ProductDetailInteractorProtocol {
    weak var presenter: ProductDetailPresenterProtocol?
    var networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func addToCart(product: Product, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])))
            return
        }
        
        networkService.addToCart(productId: product.id, quantity: 1) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
} 