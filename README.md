# AppEShop

A modern e-commerce iOS application built with Swift and Firebase.

## Features

- User authentication with Firebase
- Product browsing and search
- Shopping cart management
- Secure checkout process
- Real-time data synchronization

## Requirements

- iOS 14.0+
- Xcode 12.0+
- Swift 5.0+
- Firebase account

## Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/AppEShop.git
```

2. Install dependencies using CocoaPods:
```bash
cd AppEShop
pod install
```

3. Open the workspace in Xcode:
```bash
open AppEShop.xcworkspace
```

4. Configure Firebase:
   - Create a new Firebase project at [Firebase Console](https://console.firebase.google.com)
   - Download the `GoogleService-Info.plist` file
   - Add it to your Xcode project

## Project Structure

### Core Components

- **NetworkService**: Handles all Firebase communication
- **AuthModule**: Manages user authentication
- **ProductsModule**: Displays and manages products
- **CartModule**: Handles shopping cart functionality
- **CheckoutModule**: Manages the checkout process

### Architecture

The app follows a clean architecture pattern with:
- **View Layer**: UI components and user interaction
- **Presenter Layer**: Business logic and data transformation
- **Interactor Layer**: Data operations and API calls
- **Router Layer**: Navigation and module creation

## Firebase Configuration

### Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow users to read and write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      
      // Allow users to read and write their own cart
      match /cart/{productId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
    
    // Allow authenticated users to read products
    match /products/{productId} {
      allow read: if request.auth != null;
    }
  }
}
```

## Detailed Documentation

### Network Service
The `NetworkService` class handles all communication with Firebase Firestore. It provides methods for:
- Fetching products from the database
- Managing the user's shopping cart
- Updating user profiles

### Authentication
The app uses Firebase Authentication to manage user accounts. Users must be logged in to:
- View products
- Add items to their cart
- Complete purchases

### Shopping Cart
The cart system allows users to:
- Add products to their cart
- Update quantities of items
- Remove items from the cart
- View the total price of their cart

### Product Management
- Users can view a list of all available products
- Each product displays an image, name, price, and description
- Clicking on a product navigates to a detailed view

### Data Structure

#### Products
Products are stored in Firestore with:
- ID
- Name
- Description
- Price
- Image URL

#### Cart Items
Cart items are stored in Firestore under each user's document:
- Product ID
- Quantity
- Timestamps for when items were added or updated

#### User Profiles
User profiles contain:
- User ID (from Firebase Authentication)
- Name
- Timestamp for when the profile was last updated

## Error Handling
The app handles various error scenarios:
- Network errors when communicating with Firebase
- Authentication errors when users aren't logged in
- Data validation errors when required fields are missing

## Navigation
The app uses a navigation controller to move between different screens:
- Products list
- Product details
- Shopping cart
- Checkout

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Firebase for authentication and database services
- SwiftUI for modern UI components
- The iOS development community for inspiration and support 