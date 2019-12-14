//
//  SearchViewController.swift
//  WeatherApp
//
//  Created by Vitor Leonardi on 14/12/19.
//  Copyright © 2019 Vitor. All rights reserved.
//

import Foundation
import UIKit

protocol SearchViewControllerInterface {}

final class SearchViewController: UIViewController, SearchViewControllerInterface {
    var viewModel: SearchViewModelInterface

    lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.placeholder = "Enter a City or Zip code"
        textField.backgroundColor = .lightGray
        textField.enablesReturnKeyAutomatically = true
        textField.returnKeyType = .search
        textField.font = UIFont(name: "Arial", size: 22.0)
        return textField
    }()

    init(viewModel: SearchViewModelInterface) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        buildUI()
        viewModel.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        searchTextField.becomeFirstResponder()
    }
}

extension SearchViewController {
    // MARK: - UI Setup
    func buildUI() {
        view.backgroundColor = .white
        addSubviews()
        setConstraints()
    }

    func addSubviews() {
        view.addSubview(searchTextField)
    }

    func setConstraints() {
        setSearchTextFieldConstraints()
    }

    func setSearchTextFieldConstraints() {
        searchTextField.snp.makeConstraints { make in
            make.height.equalTo(40.0)
            make.topMargin.equalTo(Dimensions.margin * 2)
            make.leadingMargin.equalTo(Dimensions.margin * 2)
            make.trailingMargin.equalTo(-Dimensions.margin * 2)
        }
    }
}

extension SearchViewController: SearchViewModelDelegate {
    // MARK: - SearchViewModelDelegate
}

extension SearchViewController: UITextFieldDelegate {
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        viewModel.textFieldShouldReturn(textField.text)
    }
}
