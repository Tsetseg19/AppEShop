import Foundation
import FirebaseAuth

struct User {
    let id: String
    let email: String
    let displayName: String?
    
    init(id: String, email: String, displayName: String? = nil) {
        self.id = id
        self.email = email
        self.displayName = displayName
    }
    
    init(from firebaseUser: FirebaseAuth.User) {
        self.id = firebaseUser.uid
        self.email = firebaseUser.email ?? ""
        self.displayName = firebaseUser.displayName
    }
} 