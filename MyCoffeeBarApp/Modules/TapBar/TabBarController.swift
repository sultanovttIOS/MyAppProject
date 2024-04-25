//
//  TapBarViewController.swift
//  MyCoffeeBarApp
//
//  Created by Alisher Sultanov on 4/4/24.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupTabBarColors()
    }
    
    private func setupTabBar() {
        let menuViewController = createNavController(
            vc: MenuBarViewController(),
            itemName: "Menu",
            itemImage: "house")
        let basketViewController = createNavController(
            vc: BasketViewController(),
            itemName: "Basket",
            itemImage: "basket")
        let productViewController = createNavController(
            vc: SMSViewController(),
            itemName: "Product",
            itemImage: "safari")
        let profileViewController = createNavController(
            vc: ProfileTableViewController(),
            itemName: "Profile",
            itemImage: "person")
        
        viewControllers = [
            menuViewController, basketViewController,
            productViewController, profileViewController]
    }
    
    private func setupTabBarColors() {
        tabBar.backgroundColor = .white
        tabBar.tintColor = .orange
        tabBar.unselectedItemTintColor = .label
    }
    
    private func createNavController(
        vc: UIViewController,
        itemName: String,
        itemImage: String) -> UINavigationController {
            let item = UITabBarItem(
                title: itemName,
                image: UIImage(
                    systemName: itemImage)?.withAlignmentRectInsets(
                        .init(top: 10, left: 0, bottom: 0, right: 0)),
                tag: 0)
            item.titlePositionAdjustment = .init(
                horizontal: 0, vertical: 5)
            let navController = UINavigationController(
                rootViewController: vc)
            navController.tabBarItem = item
            return navController
        }
}