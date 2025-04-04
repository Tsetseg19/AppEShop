import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthInteractor: AuthInteractorProtocol {
    weak var presenter: AuthPresenterProtocol?
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    var networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    // MARK: - Authentication Methods
    func signUp(email: String, password: String, name: String, completion: @escaping (Result<User, Error>) -> Void) {
        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let firebaseUser = result?.user else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create user"])))
                return
            }
            
            // Create user profile in Firestore
            let userData: [String: Any] = [
                "id": firebaseUser.uid,
                "email": email,
                "name": name,
                "createdAt": FieldValue.serverTimestamp()
            ]
            
            self.db.collection("users").document(firebaseUser.uid).setData(userData) { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                let user = User(id: firebaseUser.uid, email: email)
                completion(.success(user))
            }
        }
    }
    
    func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let firebaseUser = result?.user else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to login"])))
                return
            }
            
            // Fetch user data from Firestore
            self.db.collection("users").document(firebaseUser.uid).getDocument { document, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = document?.data(),
                      let email = data["email"] as? String else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch user data"])))
                    return
                }
                
                let user = User(id: firebaseUser.uid, email: email)
                completion(.success(user))
            }
        }
    }
    
    func logout() throws {
        try auth.signOut()
    }
    
    func getCurrentUser() -> User? {
        guard let firebaseUser = auth.currentUser else { return nil }
        return User(id: firebaseUser.uid, email: firebaseUser.email ?? "")
    }
}
