import UIKit

class CheckoutRouter: CheckoutRouterProtocol {
    weak var viewController: UIViewController?
    
    static func createModule(networkService: NetworkServiceProtocol) -> UIViewController {
        let view = CheckoutViewController()
        let interactor = CheckoutInteractor(networkService: networkService)
        let presenter = CheckoutPresenter()
        let router = CheckoutRouter()
        
        view.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        interactor.presenter = presenter
        
        router.viewController = view
        
        return view
    }
    
    func navigateToProducts() {
        viewController?.navigationController?.popViewController(animated: true)
    }
} 