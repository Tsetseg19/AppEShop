import Foundation

protocol ProductDetailInteractorProtocol: AnyObject {
    var presenter: ProductDetailPresenterProtocol? { get set }
    var networkService: NetworkServiceProtocol { get set }
    
    // Business logic methods
    func addToCart(product: Product, completion: @escaping (Result<Void, Error>) -> Void)
} 