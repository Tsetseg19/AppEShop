import UIKit

class CartRouter: CartRouterProtocol {
    weak var viewController: UIViewController?
    var networkService: NetworkServiceProtocol?
    
    static func createModule(networkService: NetworkServiceProtocol) -> UIViewController {
        let view = CartViewController()
        let interactor = CartInteractor(networkService: networkService)
        let presenter = CartPresenter()
        let router = CartRouter()
        
        view.presenter = presenter
        interactor.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        router.viewController = view
        router.networkService = networkService
        
        return view
    }
    
    func showCheckout() {
        guard let networkService = networkService else { return }
        let checkoutModule = CheckoutRouter.createModule(networkService: networkService)
        viewController?.navigationController?.pushViewController(checkoutModule, animated: true)
    }
    
    func showProductDetail(product: Product) {
        guard let networkService = networkService else { return }
        let detailModule = ProductDetailRouter.createModule(product: product, networkService: networkService)
        viewController?.navigationController?.pushViewController(detailModule, animated: true)
    }
} 