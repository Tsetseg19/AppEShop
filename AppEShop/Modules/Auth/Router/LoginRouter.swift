import UIKit

class LoginRouter: AuthRouterProtocol {
    weak var viewController: UIViewController?
    var networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    static func createModule(networkService: NetworkServiceProtocol) -> UIViewController {
        let view = LoginViewController()
        let interactor = AuthInteractor(networkService: networkService)
        let presenter = AuthPresenter()
        let router = LoginRouter(networkService: networkService)
        
        view.presenter = presenter
        interactor.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        router.viewController = view
        
        return view
    }
    
    func navigateToHome() {
        let productsModule = ProductsRouter.createModule(networkService: networkService)
        viewController?.navigationController?.setViewControllers([productsModule], animated: true)
    }
    
    func navigateToLogin() {
        // Already on login screen
    }
    
    func navigateToSignUp() {
        let signUpModule = SignUpRouter.createModule(networkService: networkService)
        viewController?.navigationController?.pushViewController(signUpModule, animated: true)
    }
} 