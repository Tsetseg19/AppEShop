import UIKit

class CartViewController: UIViewController, CartViewProtocol {
    var presenter: CartPresenterProtocol?
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CartItemCell.self, forCellReuseIdentifier: "CartItemCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "Your cart is empty"
        label.textAlignment = .center
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 18)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let checkoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Checkout", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let totalLabel: UILabel = {
        let label = UILabel()
        label.text = "Total: $0.00"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private var cartItems: [CartItemViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        presenter?.viewDidLoad()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Cart"
        
        view.addSubview(tableView)
        view.addSubview(emptyStateLabel)
        view.addSubview(checkoutButton)
        view.addSubview(totalLabel)
        view.addSubview(activityIndicator)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: totalLabel.topAnchor, constant: -16),
            
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            totalLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            totalLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            totalLabel.bottomAnchor.constraint(equalTo: checkoutButton.topAnchor, constant: -8),
            
            checkoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            checkoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            checkoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupActions() {
        checkoutButton.addTarget(self, action: #selector(checkoutButtonTapped), for: .touchUpInside)
    }
    
    @objc private func checkoutButtonTapped() {
        presenter?.didTapCheckout()
    }
    
    // MARK: - CartViewProtocol
    func updateCartItems(_ items: [CartItemViewModel]) {
        cartItems = items
        tableView.reloadData()
        
        // Update empty state
        emptyStateLabel.isHidden = !items.isEmpty
        checkoutButton.isEnabled = !items.isEmpty
        
        // Update total
        let total = items.reduce(0) { $0 + $1.totalPrice }
        totalLabel.text = String(format: "Total: $%.2f", total)
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
}

// MARK: - UITableViewDataSource
extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartItemCell", for: indexPath) as? CartItemCell else {
            return UITableViewCell()
        }
        
        let item = cartItems[indexPath.row]
        cell.configure(with: item)
        cell.delegate = self
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Navigate to product detail
    }
}

// MARK: - CartItemCellDelegate
extension CartViewController: CartItemCellDelegate {
    func cartItemCell(_ cell: CartItemCell, didUpdateQuantity quantity: Int) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let item = cartItems[indexPath.row]
        presenter?.didTapUpdateQuantity(productId: item.productId, newQuantity: quantity)
    }
    
    func cartItemCellDidTapRemove(_ cell: CartItemCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let item = cartItems[indexPath.row]
        presenter?.didTapRemoveItem(productId: item.productId)
    }
} 