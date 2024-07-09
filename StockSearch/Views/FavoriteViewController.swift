//
//  FavoriteViewController.swift
//  StockSearch
//
//  Created by Dmitriy Mikhailov on 09.07.2024.
//

import UIKit
import SnapKit

class FavoriteViewController: UIViewController {
    
    private var listOfFavoriteCompanies: [FullCompanyInfo]?
    
    private let headerView = UIView()
    private let stockButton = UIButton(type: .system)
    private let favoriteButton = UIButton(type: .system)
    private let stockSearchController = UISearchController()
    
    private let favoriteTable = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ud = UserDefaultManager()
        listOfFavoriteCompanies = ud.loadFullCompanyInfo()
        setupUI()
        setupHeaderView()
        setupTable()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
    }
    
    private func setupHeaderView() {
        navigationItem.hidesBackButton = true
        stockButton.addTarget(self, action: #selector(showStock), for: .touchUpInside)
        
        stockButton.setTitle("Stocks", for: .normal)
        favoriteButton.setTitle("Favorite", for: .normal)
        stockButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        favoriteButton.titleLabel?.font = .systemFont(ofSize: 30, weight: .bold)
        stockButton.setTitleColor(.gray, for: .normal)
        favoriteButton.setTitleColor(.black, for: .normal)
        
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
        favoriteTable.backgroundColor = .clear
        favoriteTable.register(FavoriteCell.self, forCellReuseIdentifier: "FavoriteCell")
        favoriteTable.dataSource = self
        favoriteTable.separatorStyle = .none
        favoriteTable.showsVerticalScrollIndicator = false
        
        view.addSubview(favoriteTable)
        
        favoriteTable.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().inset(15)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    @objc func showStock() {
        navigationController?.popViewController(animated: false)
    }
    
}

extension FavoriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfFavoriteCompanies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as? FavoriteCell else { return UITableViewCell() }
        cell.configure(index: indexPath.row, model: listOfFavoriteCompanies ?? [])
        cell.delegate = self
        return cell
    }
}

extension FavoriteViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

extension FavoriteViewController: FavoriteCellDelegate {
    func reloadData() {
        let ud = UserDefaultManager()
        listOfFavoriteCompanies = ud.loadFullCompanyInfo()
        favoriteTable.reloadData()
    }
}
