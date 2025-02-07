//
//  CustomTaskCell.swift
//  AppForEM
//
//  Created by Bema on 7/2/25.
//

import Foundation
import UIKit
import SnapKit

class CustomTaskCell: UITableViewCell {
    
    static var identifier = "CustomTaskCell"
    
    private lazy var todoTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        
        return label
    }()
    
    private lazy var doneMarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.tintColor = .yellow
        button.addTarget(self, action: #selector(didTapDoneMark), for: .touchUpInside)
        return button
    }()
    
    var onDoneMarkTapped: (() -> Void)?
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.systemBackground
        
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setups
    
    private func setupHierarchy() {
        contentView.addSubview(todoTitleLabel)
        contentView.addSubview(doneMarkButton)
    }
    
    private func setupLayout() {
        todoTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        doneMarkButton.translatesAutoresizingMaskIntoConstraints = false
        
        todoTitleLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.leading.equalTo(doneMarkButton.snp.trailing).offset(8)
            make.top.bottom.equalToSuperview().inset(10)
        }
        
        doneMarkButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
    }
    
    func configure(with todo: Todo) {
        todoTitleLabel.text = todo.todo
        let imageName = todo.completed ? "checkmark.circle.fill" : "circle"
        doneMarkButton.setImage(UIImage(systemName: imageName), for: .normal)
        doneMarkButton.tintColor = todo.completed ? .yellow : .gray
    }
    
    // MARK: - Targets
    
    @objc private func didTapDoneMark() {
        onDoneMarkTapped?()
    }
    
}
