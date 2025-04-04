import UIKit

protocol CartItemCellDelegate: AnyObject {
    func cartItemCell(_ cell: CartItemCell, didUpdateQuantity quantity: Int)
    func cartItemCellDidTapRemove(_ cell: CartItemCell)
}

class CartItemCell: UITableViewCell {
    weak var delegate: CartItemCellDelegate?
    private var productId: String?
    private var quantity: Int = 1
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .systemBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let quantityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let decreaseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("-", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let increaseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let removeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.tintColor = .systemRed
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(productImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(decreaseButton)
        contentView.addSubview(quantityLabel)
        contentView.addSubview(increaseButton)
        contentView.addSubview(removeButton)
        
        NSLayoutConstraint.activate([
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            productImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            productImageView.widthAnchor.constraint(equalToConstant: 60),
            productImageView.heightAnchor.constraint(equalToConstant: 60),
            
            nameLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 12),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: removeButton.leadingAnchor, constant: -8),
            
            priceLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            
            decreaseButton.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 16),
            decreaseButton.centerYAnchor.constraint(equalTo: priceLabel.centerYAnchor),
            decreaseButton.widthAnchor.constraint(equalToConstant: 30),
            
            quantityLabel.leadingAnchor.constraint(equalTo: decreaseButton.trailingAnchor, constant: 8),
            quantityLabel.centerYAnchor.constraint(equalTo: decreaseButton.centerYAnchor),
            quantityLabel.widthAnchor.constraint(equalToConstant: 30),
            
            increaseButton.leadingAnchor.constraint(equalTo: quantityLabel.trailingAnchor, constant: 8),
            increaseButton.centerYAnchor.constraint(equalTo: quantityLabel.centerYAnchor),
            increaseButton.widthAnchor.constraint(equalToConstant: 30),
            
            removeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            removeButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            removeButton.widthAnchor.constraint(equalToConstant: 44),
            removeButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupActions() {
        decreaseButton.addTarget(self, action: #selector(decreaseButtonTapped), for: .touchUpInside)
        increaseButton.addTarget(self, action: #selector(increaseButtonTapped), for: .touchUpInside)
        removeButton.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
    }
    
    @objc private func decreaseButtonTapped() {
        if quantity > 1 {
            quantity -= 1
            delegate?.cartItemCell(self, didUpdateQuantity: quantity)
        }
    }
    
    @objc private func increaseButtonTapped() {
        quantity += 1
        delegate?.cartItemCell(self, didUpdateQuantity: quantity)
    }
    
    @objc private func removeButtonTapped() {
        delegate?.cartItemCellDidTapRemove(self)
    }
    
    func configure(with item: CartItemViewModel) {
        productId = item.productId
        quantity = item.quantity
        nameLabel.text = item.name
        priceLabel.text = String(format: "$%.2f", item.price)
        quantityLabel.text = "\(item.quantity)"
        
        // Load image using URLSession
        if let imageUrl = URL(string: item.imageUrl) {
            URLSession.shared.dataTask(with: imageUrl) { [weak self] data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.productImageView.image = image
                    }
                }
            }.resume()
        }
    }
} 