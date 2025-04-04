import UIKit

protocol CheckoutRouterProtocol: AnyObject {
    var viewController: UIViewController? { get set }
    
    static func createModule(networkService: NetworkServiceProtocol) -> UIViewController
    func navigateToProducts()
} 