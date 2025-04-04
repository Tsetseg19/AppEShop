import UIKit

class SignUpRouter: AuthRouterProtocol {
    weak var viewController: UIViewController?
    var networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    static func createModule(networkService: NetworkServiceProtocol) -> UIViewController {
        let view = SignUpViewController()
        let interactor = AuthInteractor(networkService: networkService)
        let presenter = AuthPresenter()
        let router = SignUpRouter(networkService: networkService)
        
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
        let loginModule = LoginRouter.createModule(networkService: networkService)
        viewController?.navigationController?.pushViewController(loginModule, animated: true)
    }
    
    func navigateToSignUp() {
        // Already on signup screen
    }
} 