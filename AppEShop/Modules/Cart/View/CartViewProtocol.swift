import UIKit

protocol CartViewProtocol: AnyObject {
    var presenter: CartPresenterProtocol? { get set }
    
    // View update methods
    func updateCartItems(_ items: [CartItemViewModel])
    func showLoading()
    func hideLoading()
    func showError(_ message: String)
} 