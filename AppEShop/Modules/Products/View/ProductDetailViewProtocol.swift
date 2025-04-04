import UIKit

protocol ProductDetailViewProtocol: AnyObject {
    var presenter: ProductDetailPresenterProtocol? { get set }
    
    // View update methods
    func showLoading()
    func hideLoading()
    func showError(_ message: String)
    func showSuccess(_ message: String)
} 