//
//  CoffeeBarViewController.swift
//  MyCoffeeBarApp
//
//  Created by Alisher Sultanov on 2/4/24.
//

import UIKit
import SnapKit

class  MenuBarViewController: UIViewController {
    
    private lazy var searchBar: UISearchBar = {
        let view = UISearchBar()
        view.placeholder = "Search"
        return view
        
    }()
    private lazy var menuBarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 15
        let view = UICollectionView(frame: .zero,
                                    collectionViewLayout: layout)
        view.dataSource = self
        view.delegate = self
        view.register(MenuBarCell.self,
                      forCellWithReuseIdentifier: MenuBarCell.reuseId)
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.text = "Кофе"
        view.font = .systemFont(ofSize: 24)
        view.textAlignment = .left
        view.textColor = .label
        return view
    }()
    
    private lazy var productsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 15
        let view = UICollectionView(frame: .zero,
                                    collectionViewLayout: layout)
        view.dataSource = self
        view.delegate = self
        view.register(ProductsCell.self,
                      forCellWithReuseIdentifier: ProductsCell.reuseId)
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    private var categories: [Category] = []
    private var counter = CounterModel(counter: 0)
    private var products: [Product] = []
    private let networkLayer = NetworkLayer()
    private var selectedCategory: Category? {
        didSet {
            fetchProducts(by: selectedCategory!)
        }
    }
    private var selectedCategoryIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        setupConstraints()
        setupNavigationItem()
        fetchCategories()
    }
    
    private func setupNavigationItem() {
        navigationController?.navigationItem.title = "Menu"
    }
    
    private func setupConstraints() {
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(30)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        view.addSubview(menuBarCollectionView)
        menuBarCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(16)
            make.height.equalTo(32)
            make.width.equalToSuperview()
        }
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(menuBarCollectionView.snp.bottom).offset(24)
            make.height.equalTo(24)
            make.width.equalTo(60)
            make.left.equalToSuperview().offset(16)
        }
        view.addSubview(productsCollectionView)
        productsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    private func fetchCategories() {
        networkLayer.fetchCategories { result in
            switch result {
            case .success(let categories):
                DispatchQueue.main.async {
                    self.categories = categories
                    self.selectedCategory = categories.first!
                    self.menuBarCollectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchProducts(by category: Category) {
        networkLayer.fetchProducts(by: category.strCategory) { result in
            switch result {
            case .success(let products):
                DispatchQueue.main.async {
                    self.products = products
                    self.productsCollectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension  MenuBarViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if collectionView == menuBarCollectionView {
            return categories.count
        } else if collectionView == productsCollectionView {
            return products.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == menuBarCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuBarCell.reuseId,
                                                          for: indexPath) as! MenuBarCell
            let model = categories[indexPath.row]
            cell.fill(with: model)
            cell.backgroundColor = indexPath.item == selectedCategoryIndex ? .red : .clear
            return cell
        } else if collectionView == productsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductsCell.reuseId,
                                                          for: indexPath) as! ProductsCell
            let model = products[indexPath.row]
            cell.fill(with: model)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

extension  MenuBarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == productsCollectionView {
            return CGSize(width: 343, height: 89)
        } else if collectionView == menuBarCollectionView {
            switch indexPath.row {
            case 0...14:
                return CGSize(width: 105, height: 32)
            default:
                return CGSize(width: view.frame.width, height: 32)
            }
        } else {
            return CGSize(width: 343, height: 89)
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int) -> UIEdgeInsets {
            if collectionView == productsCollectionView {
                return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            } else if collectionView == menuBarCollectionView {
                return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
            }
            return UIEdgeInsets()
        }
}

extension  MenuBarViewController: ProductCellDelegate {
    func increase() {
        counter.counter -= 1
        if counter.counter < 0 {
            counter.counter = 0
        }
        productsCollectionView.reloadData()
    }

    func dicrease() {
        counter.counter += 1
        if counter.counter > 10 {
            counter.counter = 10
        }
        productsCollectionView.reloadData()
    }
}

extension MenuBarViewController: UICollectionViewDelegate {
    
    //MARK: didSelectItemAt
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        guard collectionView == menuBarCollectionView else { return }
               selectedCategoryIndex = indexPath.item
               menuBarCollectionView.reloadData()
               let category = categories[indexPath.item]
               selectedCategory = category
        
        guard collectionView == productsCollectionView else { return }
        if indexPath.item <= products.count {
            let vc = ProductViewController()
            
        }
    }
    
    //MARK: didDeselectItemAt
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}