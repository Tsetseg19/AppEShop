import Foundation

protocol CartInteractorProtocol: AnyObject {
    var presenter: CartPresenterProtocol? { get set }
    var networkService: NetworkServiceProtocol { get set }
    
    func fetchCartItems()
    func updateCartItemQuantity(productId: String, newQuantity: Int)
    func removeCartItem(productId: String)
} 