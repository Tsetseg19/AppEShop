import Foundation

struct CartItemViewModel {
    let id: String
    let productId: String
    let name: String
    let price: Double
    let quantity: Int
    let imageUrl: String
    
    var totalPrice: Double {
        return price * Double(quantity)
    }
    
    init(product: Product, quantity: Int) {
        self.id = "\(product.id)_\(quantity)"
        self.productId = product.id
        self.name = product.name
        self.price = product.price
        self.quantity = quantity
        self.imageUrl = product.imageURL
    }
} 