import Foundation

protocol CartPresenterProtocol: AnyObject {
    var view: CartViewProtocol? { get set }
    var interactor: CartInteractorProtocol? { get set }
    var router: CartRouterProtocol? { get set }
    
    // View lifecycle methods
    func viewDidLoad()
    
    // Interactor callbacks
    func didFetchCartItems(_ items: [CartItemViewModel])
    func didFailToFetchCartItems(error: Error)
    func didUpdateCartItemQuantity(productId: String, newQuantity: Int)
    func didFailToUpdateCartItemQuantity(error: Error)
    func didRemoveCartItem(productId: String)
    func didFailToRemoveCartItem(error: Error)
    
    // User actions
    func didTapCheckout()
    func didTapUpdateQuantity(productId: String, newQuantity: Int)
    func didTapRemoveItem(productId: String)
} 