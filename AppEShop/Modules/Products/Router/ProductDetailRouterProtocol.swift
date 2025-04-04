import UIKit

protocol ProductDetailRouterProtocol: AnyObject {
    static func createModule(product: Product, networkService: NetworkServiceProtocol) -> UIViewController
    
    var viewController: UIViewController? { get set }
    var networkService: NetworkServiceProtocol { get set }
} 