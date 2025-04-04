import UIKit

protocol ProductsViewProtocol: AnyObject {
    var presenter: ProductsPresenterProtocol? { get set }
    
    // View update methods
    func updateProductsList(_ products: [Product])
    func showLoading()
    func hideLoading()
    func showError(_ message: String)
    func showSuccess(_ message: String)
} 