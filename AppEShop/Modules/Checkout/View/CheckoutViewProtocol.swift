import UIKit

protocol CheckoutViewProtocol: AnyObject {
    var presenter: CheckoutPresenterProtocol? { get set }
    
    func updateTotal(_ total: Double)
    func showLoading()
    func hideLoading()
    func showError(_ message: String)
    func showSuccess(_ message: String)
} 