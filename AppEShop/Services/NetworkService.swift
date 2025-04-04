import Foundation
import FirebaseFirestore
import FirebaseAuth

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case serverError(String)
    case unauthorized
    case unknown
}

protocol NetworkServiceProtocol {
    func fetchProducts(completion: @escaping (Result<[Product], NetworkError>) -> Void)
    func fetchProduct(id: String, completion: @escaping (Result<Product, NetworkError>) -> Void)
    func addToCart(productId: String, quantity: Int, completion: @escaping (Result<Void, NetworkError>) -> Void)
    func fetchCart(completion: @escaping (Result<[CartItem], NetworkError>) -> Void)
    func updateUserProfile(name: String, completion: @escaping (Result<Void, NetworkError>) -> Void)
    func fetchCartItems(userId: String, completion: @escaping (Result<[CartItem], Error>) -> Void)
    func updateCartItemQuantity(userId: String, productId: String, quantity: Int, completion: @escaping (Result<[CartItem], Error>) -> Void)
    func removeCartItem(userId: String, productId: String, completion: @escaping (Result<[CartItem], Error>) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    private let db = Firestore.firestore()
    
    // MARK: - Products
    func fetchProducts(completion: @escaping (Result<[Product], NetworkError>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(.unauthorized))
            return
        }
        
        db.collection("products").getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(.serverError(error.localizedDescription)))
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion(.failure(.noData))
                return
            }
            
            let products = documents.compactMap { document -> Product? in
                let data = document.data()
                
                guard let name = data["name"] as? String,
                      let description = data["description"] as? String,
                      let price = data["price"] as? Double,
                      let imageUrl = data["image_url"] as? String else {
                    return nil
                }
                
                return Product(
                    id: document.documentID,
                    name: name,
                    price: price,
                    description: description,
                    imageURL: imageUrl
                )
            }
            
            print("Fetched \(products.count) products from Firestore")
            completion(.success(products))
        }
    }
    
    func fetchProduct(id: String, completion: @escaping (Result<Product, NetworkError>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(.unauthorized))
            return
        }
        
        db.collection("products").document(id).getDocument { snapshot, error in
            if let error = error {
                completion(.failure(.serverError(error.localizedDescription)))
                return
            }
            
            guard let document = snapshot, document.exists,
                  let data = document.data() else {
                completion(.failure(.noData))
                return
            }
            
            guard let name = data["name"] as? String,
                  let description = data["description"] as? String,
                  let price = data["price"] as? Double,
                  let imageUrl = data["image_url"] as? String else {
                completion(.failure(.decodingError))
                return
            }
            
            let product = Product(
                id: document.documentID,
                name: name,
                price: price,
                description: description,
                imageURL: imageUrl
            )
            
            completion(.success(product))
        }
    }
    
    // MARK: - Cart
    func addToCart(productId: String, quantity: Int, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(.unauthorized))
            return
        }
        
        let cartRef = db.collection("users").document(userId).collection("cart").document(productId)
        
        cartRef.getDocument { snapshot, error in
            if let error = error {
                completion(.failure(.serverError(error.localizedDescription)))
                return
            }
            
            if let snapshot = snapshot, snapshot.exists {
                // Update existing cart item
                let currentQuantity = snapshot.data()?["quantity"] as? Int ?? 0
                let newQuantity = currentQuantity + quantity
                
                cartRef.setData([
                    "productId": productId,
                    "quantity": newQuantity,
                    "updatedAt": FieldValue.serverTimestamp()
                ], merge: true) { error in
                    if let error = error {
                        completion(.failure(.serverError(error.localizedDescription)))
                    } else {
                        completion(.success(()))
                    }
                }
            } else {
                // Create new cart item
                let cartData: [String: Any] = [
                    "productId": productId,
                    "quantity": quantity,
                    "addedAt": FieldValue.serverTimestamp(),
                    "updatedAt": FieldValue.serverTimestamp()
                ]
                
                cartRef.setData(cartData) { error in
                    if let error = error {
                        completion(.failure(.serverError(error.localizedDescription)))
                    } else {
                        completion(.success(()))
                    }
                }
            }
        }
    }
    
    func fetchCart(completion: @escaping (Result<[CartItem], NetworkError>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(.unauthorized))
            return
        }
        
        db.collection("users").document(userId).collection("cart").getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(.serverError(error.localizedDescription)))
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion(.success([]))
                return
            }
            
            let cartItems = documents.compactMap { document -> CartItem? in
                let data = document.data()
                guard let productId = data["productId"] as? String,
                      let quantity = data["quantity"] as? Int else {
                    return nil
                }
                
                return CartItem(productId: productId, quantity: quantity)
            }
            
            completion(.success(cartItems))
        }
    }
    
    // MARK: - User Profile
    func updateUserProfile(name: String, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(.unauthorized))
            return
        }
        
        let userData: [String: Any] = [
            "name": name,
            "updatedAt": FieldValue.serverTimestamp()
        ]
        
        db.collection("users").document(userId).setData(userData, merge: true) { error in
            if let error = error {
                completion(.failure(.serverError(error.localizedDescription)))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func fetchCartItems(userId: String, completion: @escaping (Result<[CartItem], Error>) -> Void) {
        db.collection("users").document(userId).collection("cart").getDocuments(source: .default) { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion(.success([]))
                return
            }
            
            let cartItems = documents.compactMap { document -> CartItem? in
                let data = document.data()
                guard let productId = data["productId"] as? String,
                      let quantity = data["quantity"] as? Int else {
                    return nil
                }
                return CartItem(productId: productId, quantity: quantity)
            }
            
            completion(.success(cartItems))
        }
    }
    
    func updateCartItemQuantity(userId: String, productId: String, quantity: Int, completion: @escaping (Result<[CartItem], Error>) -> Void) {
        let cartRef = db.collection("users").document(userId).collection("cart").document(productId)
        
        cartRef.updateData([
            "quantity": quantity,
            "updatedAt": FieldValue.serverTimestamp()
        ]) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Fetch updated cart items
            self.fetchCartItems(userId: userId, completion: completion)
        }
    }
    
    func removeCartItem(userId: String, productId: String, completion: @escaping (Result<[CartItem], Error>) -> Void) {
        let cartRef = db.collection("users").document(userId).collection("cart").document(productId)
        
        cartRef.delete { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Fetch updated cart items
            self.fetchCartItems(userId: userId, completion: completion)
        }
    }
} 