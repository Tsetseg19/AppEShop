import Foundation
import FirebaseFirestore
import FirebaseCore
import FirebaseAuth

class ProductsInteractor: ProductsInteractorProtocol {
    weak var presenter: ProductsPresenterProtocol?
    private var db: Firestore?
    var networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
        // Ensure Firebase is initialized
        if FirebaseApp.app() != nil {
            db = Firestore.firestore()
            print("Firestore initialized successfully")
        } else {
            print("Firebase not initialized yet")
        }
    }
    
    func fetchProducts(completion: @escaping (Result<[Product], NetworkError>) -> Void) {
        networkService.fetchProducts(completion: completion)
    }
    
    func addToCart(product: Product, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(.unauthorized))
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
    
    func removeFromCart(product: Product) {
        // Implement cart functionality
    }
}
