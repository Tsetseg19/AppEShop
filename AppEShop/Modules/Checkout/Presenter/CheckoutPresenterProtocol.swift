import Foundation

protocol CheckoutPresenterProtocol: AnyObject {
    var view: CheckoutViewProtocol? { get set }
    var interactor: CheckoutInteractorProtocol? { get set }
    var router: CheckoutRouterProtocol? { get set }
    
    func viewDidLoad()
    func didTapCompleteCheckout()
    func didTapContinueShopping()
    
    // Interactor callbacks
    func didFetchCartTotal(_ total: Double)
    func didFailToFetchCartTotal(error: Error)
    func didCompleteCheckout()
    func didFailToCompleteCheckout(error: Error)
} 