//
//  ViewController.swift
//  StockSearch
//
//  Created by Dmitriy Mikhailov on 09.07.2024.
//

import UIKit
import SnapKit

class StockViewController: UIViewController {

    private let viewModel = StockViewModel()
    
    var favoriteCompany: [FullCompanyInfo]?
    
    private var listOfCompany: [FullCompanyInfo]! {
        didSet {
            loadLabel.isHidden = true
            setupHeaderView()
            setupTable()
            updateTable = true
        }
    }
    
    var searchResults = [FullCompanyInfo]() {
        didSet {
            searchStatus = true
            stockTable.reloadData()
        }
    }
    
    private var updateTable = false
    private var searchStatus = false
    
    private let loadLabel = UILabel()
    
    private let headerView = UIView()
    private let stockButton = UIButton(type: .system)
    private let favoriteButton = UIButton(type: .system)
    
    private let stockSearchController = UISearchController()
    
    private let stockTable = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.fetchSymbols()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if updateTable {
            stockTable.reloadData()
        }
    }
    
    private func setupUI() {
        loadLabel.textColor = .black
        loadLabel.text = "Загрузка..."
        view.backgroundColor = .white
        view.addSubview(loadLabel)
    }
    
    private func setupConstraints() {
        loadLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
    
    private func setupHeaderView() {
        favoriteButton.addTarget(self, action: #selector(showFavorite), for: .touchUpInside)
        
        stockButton.setTitle("Stocks", for: .normal)
        favoriteButton.setTitle("Favorite", for: .normal)
        stockButton.titleLabel?.font = .systemFont(ofSize: 30, weight: .bold)
        favoriteButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        stockButton.setTitleColor(.black, for: .normal)
        favoriteButton.setTitleColor(.gray, for: .normal)
        
        headerView.addSubview(stockButton)
        headerView.addSubview(favoriteButton)
        
        stockButton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.top.equalToSuperview().offset(15)
            $0.bottom.equalToSuperview().inset(15)
        }
        
        favoriteButton.snp.makeConstraints {
            $0.left.equalTo(stockButton.snp.right).offset(15)
            $0.top.equalToSuperview().offset(15)
            $0.bottom.equalToSuperview().inset(15)
            $0.right.equalToSuperview().inset(120)
        }
        
        navigationItem.titleView = headerView
        
        stockSearchController.searchResultsUpdater = self
        stockSearchController.obscuresBackgroundDuringPresentation = false
        stockSearchController.hidesNavigationBarDuringPresentation = true
        navigationItem.searchController = stockSearchController
        navigationItem.hidesSearchBarWhenScrolling = true
        
        stockSearchController.searchBar.tintColor = .black
        
        navigationItem.searchController = stockSearchController
    }
    
    private func setupTable() {
        stockTable.register(StockCell.self, forCellReuseIdentifier: "StockCell")
        stockTable.showsVerticalScrollIndicator = false
        stockTable.dataSource = self
        stockTable.delegate = self
        stockTable.separatorStyle = .none
        stockTable.backgroundColor = .clear
        
        view.addSubview(stockTable)
        
        stockTable.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().inset(15)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func bindViewModel() {
        viewModel.loadStatus.bind { [weak self] loadText in
            self?.loadLabel.text = loadText
        }
        viewModel.listOfFullCompanies.bind { listFullCompanies in
            self.listOfCompany = listFullCompanies
        }
    }
    
    @objc func showFavorite() {
        let favoriteViewController = FavoriteViewController()
        navigationController?.pushViewController(favoriteViewController, animated: false)
    }

    func searchTable(searchText: String) {
        var arrayOfResults = [FullCompanyInfo]()
        
        for element in listOfCompany {
            if element.symbol.contains(searchText) {
                print("Результаты")
                print(element.symbol)
                arrayOfResults.append(element)
            }
        }
        searchResults = arrayOfResults
    }
    

}

extension StockViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchStatus ? searchResults.count : listOfCompany.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StockCell", for: indexPath) as? StockCell else { return UITableViewCell() }
        
        let userDefaultManager = UserDefaultManager()
        favoriteCompany = userDefaultManager.loadFullCompanyInfo()
        
        cell.configure(index: indexPath.row, model: searchStatus ? searchResults : listOfCompany, favoriteCompany: favoriteCompany)
        return cell
    }
}

extension StockViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
}

extension StockViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            searchStatus = false
            stockTable.reloadData()
            return
        }
        searchTable(searchText: searchText.uppercased())
    }
}
