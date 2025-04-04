import Foundation

protocol CheckoutInteractorProtocol: AnyObject {
    var presenter: CheckoutPresenterProtocol? { get set }
    var networkService: NetworkServiceProtocol { get }
    
    func fetchCartTotal(completion: @escaping (Result<Double, Error>) -> Void)
    func completeCheckout(completion: @escaping (Result<Void, Error>) -> Void)
} 