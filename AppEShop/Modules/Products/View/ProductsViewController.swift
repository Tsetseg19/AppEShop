import UIKit
import FirebaseFirestore
import FirebaseAuth

class ProductsViewController: UIViewController, ProductsViewProtocol {
    var presenter: ProductsPresenterProtocol?
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: "ProductCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private var products: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        presenter?.viewDidLoad()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Products"
        
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        let cartButton = UIBarButtonItem(
            image: UIImage(systemName: "cart"),
            style: .plain,
            target: self,
            action: #selector(cartButtonTapped)
        )
        navigationItem.rightBarButtonItem = cartButton
        
        let logoutButton = UIBarButtonItem(
            title: "Logout",
            style: .plain,
            target: self,
            action: #selector(logoutButtonTapped)
        )
        navigationItem.leftBarButtonItem = logoutButton
    }
    
    @objc private func logoutButtonTapped() {
        do {
            try Auth.auth().signOut()
            // Navigate to home page
            let authModule = AuthRouter.createModule(networkService: (presenter?.router?.networkService)!)
            navigationController?.setViewControllers([authModule], animated: true)
        } catch {
            showError("Failed to logout: \(error.localizedDescription)")
        }
    }
    
    @objc private func cartButtonTapped() {
        presenter?.didTapCart()
    }
    
    // MARK: - ProductsViewProtocol
    func updateProductsList(_ products: [Product]) {
        print("Updating products list with \(products.count) products")
        self.products = products
        collectionView.reloadData()
    }
    
    func showLoading() {
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showSuccess(_ message: String) {
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension ProductsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as? ProductCell else {
            return UICollectionViewCell()
        }
        
        let product = products[indexPath.item]
        cell.configure(with: product)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension ProductsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = products[indexPath.item]
        presenter?.didSelectProduct(product)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ProductsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 48) / 2 // 48 = left padding (16) + right padding (16) + spacing between items (16)
        return CGSize(width: width, height: width * 1.5)
    }
} 
