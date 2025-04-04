import UIKit

protocol LoginRouterProtocol: AnyObject {
    static func createModule(networkService: NetworkServiceProtocol) -> UIViewController
    
    var viewController: UIViewController? { get set }
    var networkService: NetworkServiceProtocol { get set }
} 