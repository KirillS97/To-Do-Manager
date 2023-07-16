//
//  MyCell.swift
//  To-Do Manager
//
//  Created by Kirill on 13.07.2023.
//

import UIKit

class MyCell: UITableViewCell {
    
    var label    : UILabel!
    var stackView: UIStackView!
    var view     : UIView!

    private func setUpLabel() -> UILabel {
        let label = UILabel()
        label.backgroundColor = .systemRed
        label.text = "Label"
        label.font = .systemFont(ofSize: 25, weight: .heavy)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }

    func setUpLabelText(text: String) -> Void {
        self.label.text = text
    }

    private func setUpView() -> UIView {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 50),
            view.heightAnchor.constraint(equalToConstant: 50)
        ])
        return view
    }

    private func setUpStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.backgroundColor = .brown
        stackView.axis = .horizontal
        stackView.spacing = 50
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.isLayoutMarginsRelativeArrangement = true
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        return stackView
    }


    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .systemRed
        self.stackView = self.setUpStackView()
        self.label = self.setUpLabel()
        self.view = self.setUpView()
        self.stackView.addArrangedSubview(self.label)
        self.stackView.addArrangedSubview(self.view)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
