import Foundation

protocol ProductsInteractorProtocol: AnyObject {
    var presenter: ProductsPresenterProtocol? { get set }
    var networkService: NetworkServiceProtocol { get set }
    
    // Business logic methods
    func fetchProducts(completion: @escaping (Result<[Product], NetworkError>) -> Void)
    func addToCart(product: Product, completion: @escaping (Result<Void, NetworkError>) -> Void)
    func removeFromCart(product: Product)
} 