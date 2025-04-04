import Foundation

protocol AuthInteractorProtocol: AnyObject {
    var presenter: AuthPresenterProtocol? { get set }
    var networkService: NetworkServiceProtocol { get set }
    
    // Authentication methods
    func signUp(email: String, password: String, name: String, completion: @escaping (Result<User, Error>) -> Void)
    func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void)
    func logout() throws
    func getCurrentUser() -> User?
} 