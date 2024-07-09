//
//  StockCell.swift
//  StockSearch
//
//  Created by Dmitriy Mikhailov on 09.07.2024.
//

import UIKit

class StockCell: UITableViewCell {
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = true
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var symbolLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private lazy var companyNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var currentPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private lazy var precentChangeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .black
        return label
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "star.fill")
        button.setImage(image, for: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var symbolButtonStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.addArrangedSubview(symbolLabel)
        stack.addArrangedSubview(favoriteButton)
        return stack
    }()
    
    private lazy var companyInfoStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.addArrangedSubview(symbolButtonStack)
        stack.addArrangedSubview(companyNameLabel)
        stack.spacing = 3
        return stack
    }()
    
    private lazy var priceStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.addArrangedSubview(currentPriceLabel)
        stack.addArrangedSubview(precentChangeLabel)
        stack.spacing = 3
        return stack
    }()
    
    var listOfCompany: [FullCompanyInfo]!
    var index: Int!
//    var favoriteCompnay: [FullCompanyInfo]?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.backgroundColor = .white
        self.favoriteButton.tintColor = .gray
    }
    
    private func setup() {
        contentView.addSubview(logoImageView)
        contentView.addSubview(companyInfoStack)
        contentView.addSubview(priceStack)
        setupConstraints()
        
    }
    
    private func setupConstraints() {
        
        logoImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.left.equalToSuperview().offset(15)
            $0.bottom.equalToSuperview().inset(15)
            $0.width.equalTo(70)
            $0.height.equalTo(70)
        }
        
        companyInfoStack.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.left.equalTo(logoImageView.snp.right).offset(10)
            $0.bottom.equalToSuperview().inset(15)
            $0.width.equalToSuperview().multipliedBy(0.3)
        }
        
        priceStack.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.left.equalTo(companyInfoStack.snp.right).offset(15)
            $0.bottom.equalToSuperview().inset(15)
            $0.right.equalToSuperview().inset(5)
        }
        
    }
    
    func configure(index: Int, model: [FullCompanyInfo], favoriteCompany: [FullCompanyInfo]?) {
        let image = UIImage(data: model[index].imageData)
        let symbol = model[index].symbol
        let companyName = model[index].companyName
        let currentPrice = model[index].currentPrice
        let percentChange = model[index].percentChange
        let changeValue = model[index].changeValue
        
        logoImageView.image = image
        symbolLabel.text = symbol
        companyNameLabel.text = companyName
        currentPriceLabel.text = "$" + String(currentPrice)
        precentChangeLabel.text = (percentChange > 0 ? "+" : "") + String(format: "%.2f",changeValue) + "(" + String(format: "%.2f", percentChange) + "%)"
        precentChangeLabel.textColor = percentChange < 0 ? .red : .green
        precentChangeLabel.textColor = percentChange < 0 || percentChange > 0 ? precentChangeLabel.textColor : .black
        
        self.backgroundColor = index % 2 == 0 ? UIColor(named: "SeconCellColor") : .white
        self.layer.cornerRadius = 15
        self.index = index
        self.listOfCompany = model
        
        guard let companies = favoriteCompany else { return }
        
        for company in companies {
            if company.symbol == symbol {
                favoriteButton.tintColor = .orange
            }
        }
    }
    
    @objc private func favoriteButtonTapped() {
        let userManager = UserDefaultManager()
        
        if favoriteButton.tintColor == .gray {
            userManager.addFullCompanyInfo(listOfCompany[index])
            favoriteButton.tintColor = .orange
        } else if favoriteButton.tintColor == .orange {
            userManager.removeFullCompanyInfo(symbol: listOfCompany[index].symbol)
            favoriteButton.tintColor = .gray
        }
        
    }
    
}

