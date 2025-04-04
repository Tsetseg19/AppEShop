import Foundation

protocol AuthPresenterProtocol: AnyObject {
    var view: AuthViewProtocol? { get set }
    var interactor: AuthInteractorProtocol? { get set }
    var router: AuthRouterProtocol? { get set }
    
    // User actions
    func viewDidLoad()
    func didTapLogin(email: String, password: String)
    func didTapSignUp(email: String, password: String, name: String)
    func didTapLogout()
    
    // Navigation Actions
    func didTapNavigateToLogin()
    func didTapNavigateToSignUp()
    
    // Interactor callbacks
    func didSignUpSuccessfully()
    func didLoginSuccessfully()
    func didLogoutSuccessfully()
    func didFailToSignUp(error: Error)
    func didFailToLogin(error: Error)
    func didFailToLogout(error: Error)
} 