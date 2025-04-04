import Foundation

protocol ProductsPresenterProtocol: AnyObject {
    var view: ProductsViewProtocol? { get set }
    var interactor: ProductsInteractorProtocol? { get set }
    var router: ProductsRouterProtocol? { get set }
    
    // View lifecycle methods
    func viewDidLoad()
    
    // Interactor callbacks
    func didFetchProducts(products: [Product])
    func didFailToFetchProducts(error: NetworkError)
    func didFailToAddToCart(error: NetworkError)
    
    // User actions
    func didSelectProduct(_ product: Product)
    func didTapAddToCart(_ product: Product)
    func didTapCart()
} 