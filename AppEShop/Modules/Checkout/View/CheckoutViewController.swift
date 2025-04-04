import UIKit

class CheckoutViewController: UIViewController, CheckoutViewProtocol {
    var presenter: CheckoutPresenterProtocol?
    
    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let totalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.text = "Total: $0.00"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let completeCheckoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Complete Checkout", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let continueShoppingButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Continue Shopping", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .systemGray5
        button.setTitleColor(.systemBlue, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        presenter?.viewDidLoad()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Checkout"
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        view.addSubview(activityIndicator)
        
        stackView.addArrangedSubview(totalLabel)
        stackView.addArrangedSubview(completeCheckoutButton)
        stackView.addArrangedSubview(continueShoppingButton)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            completeCheckoutButton.heightAnchor.constraint(equalToConstant: 44),
            continueShoppingButton.heightAnchor.constraint(equalToConstant: 44),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupActions() {
        completeCheckoutButton.addTarget(self, action: #selector(completeCheckoutButtonTapped), for: .touchUpInside)
        continueShoppingButton.addTarget(self, action: #selector(continueShoppingButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func completeCheckoutButtonTapped() {
        presenter?.didTapCompleteCheckout()
    }
    
    @objc private func continueShoppingButtonTapped() {
        presenter?.didTapContinueShopping()
    }
    
    // MARK: - CheckoutViewProtocol
    func updateTotal(_ total: Double) {
        totalLabel.text = String(format: "Total: $%.2f", total)
    }
    
    func showLoading() {
        activityIndicator.startAnimating()
        completeCheckoutButton.isEnabled = false
        continueShoppingButton.isEnabled = false
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
        completeCheckoutButton.isEnabled = true
        continueShoppingButton.isEnabled = true
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showSuccess(_ message: String) {
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.presenter?.didTapContinueShopping()
        })
        present(alert, animated: true)
    }
} 