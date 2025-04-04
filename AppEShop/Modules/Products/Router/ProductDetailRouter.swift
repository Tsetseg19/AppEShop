import UIKit

class ProductDetailRouter: ProductDetailRouterProtocol {
    weak var viewController: UIViewController?
    var networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    static func createModule(product: Product, networkService: NetworkServiceProtocol) -> UIViewController {
        let view = ProductDetailViewController()
        let interactor = ProductDetailInteractor(networkService: networkService)
        let presenter = ProductDetailPresenter()
        let router = ProductDetailRouter(networkService: networkService)
        
        view.presenter = presenter
        interactor.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        router.viewController = view
        
        // Set the product
        view.product = product
        
        return view
    }
} 