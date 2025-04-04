import UIKit

protocol CartRouterProtocol: AnyObject {
    var viewController: UIViewController? { get set }
    
    func showCheckout()
    func showProductDetail(product: Product)
} 