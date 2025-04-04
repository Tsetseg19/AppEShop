import UIKit

protocol AuthViewProtocol: AnyObject {
    var presenter: AuthPresenterProtocol? { get set }
    
    // View update methods
    func showLoading()
    func hideLoading()
    func showError(_ message: String)
} 