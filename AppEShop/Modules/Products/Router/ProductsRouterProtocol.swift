import UIKit

protocol ProductsRouterProtocol: AnyObject {
    static func createModule(networkService: NetworkServiceProtocol) -> UIViewController
    
    // Navigation methods
    func showProductDetail(product: Product)
    func showCart()
    func showCheckout()
    
    var viewController: UIViewController? { get set }
    var networkService: NetworkServiceProtocol { get set }
} 