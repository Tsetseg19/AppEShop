import Foundation

struct Product: Codable, Identifiable {
    var id: String
    let name: String
    let price: Double
    let description: String
    let imageURL: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case price
        case description
        case imageURL = "image_url"
    }
    
    init(id: String = UUID().uuidString,
         name: String,
         price: Double,
         description: String,
         imageURL: String) {
        self.id = id
        self.name = name
        self.price = price
        self.description = description
        self.imageURL = imageURL
    }
    
    init?(dictionary: [String: Any], id: String) {
        guard let name = dictionary["name"] as? String,
              let price = dictionary["price"] as? Double,
              let description = dictionary["description"] as? String,
              let imageURL = dictionary["image_url"] as? String else {
            return nil
        }
        
        self.id = id
        self.name = name
        self.price = price
        self.description = description
        self.imageURL = imageURL
    }
}
