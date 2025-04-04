import Foundation

protocol ProductDetailPresenterProtocol: AnyObject {
    var view: ProductDetailViewProtocol? { get set }
    var interactor: ProductDetailInteractorProtocol? { get set }
    var router: ProductDetailRouterProtocol? { get set }
    
    // View lifecycle methods
    func viewDidLoad()
    
    // User actions
    func didTapAddToCart(_ product: Product)
    
    // Interactor callbacks
    func didAddToCartSuccessfully()
    func didFailToAddToCart(error: Error)
} 