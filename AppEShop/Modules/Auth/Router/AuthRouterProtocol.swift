import UIKit

protocol AuthRouterProtocol: AnyObject {
    var viewController: UIViewController? { get set }
    var networkService: NetworkServiceProtocol { get set }
    
    // Navigation methods
    func navigateToHome()
    func navigateToLogin()
    func navigateToSignUp()
} 