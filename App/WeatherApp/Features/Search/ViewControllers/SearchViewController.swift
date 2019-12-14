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

    lazy var searchTextView: UITextView = {
        let textView = UITextView()
        textView.delegate = self
        textView.backgroundColor = .lightGray
        textView.font = UIFont(name: "Arial", size: 22.0)
        textView.keyboardDismissMode = .onDrag
        return textView
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
//        viewModel.delegate = self
        buildUI()
        viewModel.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        searchTextView.becomeFirstResponder()
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
        view.addSubview(searchTextView)
    }

    func setConstraints() {
        setSearchTextViewConstraints()
    }

    func setSearchTextViewConstraints() {
        searchTextView.snp.makeConstraints { make in
            make.height.equalTo(40.0)
            make.topMargin.equalTo(Dimensions.margin * 2)
            make.leadingMargin.equalTo(Dimensions.margin * 2)
            make.trailingMargin.equalTo(-Dimensions.margin * 2)
        }
    }
}

extension SearchViewController: UITextViewDelegate {

}
