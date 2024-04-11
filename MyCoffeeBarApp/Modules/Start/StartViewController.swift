//
//  ViewController.swift
//  MyCoffeeBarApp
//
//  Created by Alisher Sultanov on 2/4/24.
//

import UIKit
import SnapKit

class StartViewController: UIViewController {

    private let startView = StartView(frame: .zero)
    
    deinit {
        print("StartViewController deinited")
    }
    
    override func loadView() {
        super.loadView()
        view = startView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        startView.didLoginBtnTapped = { [weak self] in
            guard let self else { return }
            let vc = AuthorizationViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

