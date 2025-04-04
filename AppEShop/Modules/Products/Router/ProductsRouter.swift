import UIKit

class ProductsRouter: ProductsRouterProtocol {
    weak var viewController: UIViewController?
    var networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    static func createModule(networkService: NetworkServiceProtocol) -> UIViewController {
        let view = ProductsViewController()
        let interactor = ProductsInteractor(networkService: networkService)
        let presenter = ProductsPresenter()
        let router = ProductsRouter(networkService: networkService)
        
        view.presenter = presenter
        interactor.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        router.viewController = view
        
        return view
    }
    
    func showProductDetail(product: Product) {
        let detailModule = ProductDetailRouter.createModule(product: product, networkService: networkService)
        viewController?.navigationController?.pushViewController(detailModule, animated: true)
    }
    
    func showCart() {
        let cartModule = CartRouter.createModule(networkService: networkService)
        viewController?.navigationController?.pushViewController(cartModule, animated: true)
    }
    
    func showCheckout() {
        let checkoutModule = CheckoutRouter.createModule(networkService: networkService)
        viewController?.navigationController?.pushViewController(checkoutModule, animated: true)
    }
} 