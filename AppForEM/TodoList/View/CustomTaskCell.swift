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
    
    // MARK: - UI
    
    private lazy var descriptionOfTaskLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var todoTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
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

        
        let interaction = UIContextMenuInteraction(delegate: self)
        self.addInteraction(interaction)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setups
    
    private func setupHierarchy() {
        contentView.addSubview(descriptionOfTaskLabel)
        contentView.addSubview(todoTitleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(doneMarkButton)
    }
    
    private func setupLayout() {
        descriptionOfTaskLabel.translatesAutoresizingMaskIntoConstraints = false
        todoTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        doneMarkButton.translatesAutoresizingMaskIntoConstraints = false
        
        descriptionOfTaskLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalTo(doneMarkButton.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        todoTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionOfTaskLabel.snp.bottom).offset(4)
            make.leading.trailing.equalTo(descriptionOfTaskLabel)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(todoTitleLabel.snp.bottom).offset(4)
            make.leading.trailing.equalTo(descriptionOfTaskLabel)
            make.bottom.equalToSuperview().offset(-10).priority(.low)
        }
        
        doneMarkButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(8)
            make.width.height.lessThanOrEqualTo(24)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        descriptionOfTaskLabel.invalidateIntrinsicContentSize()
        todoTitleLabel.invalidateIntrinsicContentSize()
        dateLabel.invalidateIntrinsicContentSize()
        doneMarkButton.invalidateIntrinsicContentSize()
    }
    
    func configure(with todo: Notes) {
        let textAttributes: [NSAttributedString.Key: Any] = todo.completed ? [.strikethroughStyle: NSUnderlineStyle.single.rawValue, .foregroundColor: UIColor.gray] : [:]
        todoTitleLabel.attributedText = NSAttributedString(string: todo.todo ?? "", attributes: textAttributes)
        
        descriptionOfTaskLabel.attributedText = NSAttributedString(string: todo.descriptionOfTask ?? "Описание отсутствует",
        attributes: textAttributes)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        dateLabel.text = formatter.string(from: todo.date ?? Date())
        
        let imageName = todo.completed ? "checkmark.circle" : "circle"
        doneMarkButton.setImage(UIImage(systemName: imageName), for: .normal)
        doneMarkButton.tintColor = todo.completed ? .systemYellow : .gray
    }
    
    // MARK: - Targets
    
    @objc private func didTapDoneMark() {
        onDoneMarkTapped?()
    }
    
}

extension CustomTaskCell: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            return UIMenu(children: [
                UIAction(title: "Редактировать", image: UIImage(systemName: "pencil"), handler: { _ in
                    print("Редактировать")
                }),
                UIAction(title: "Поделиться", image: UIImage(systemName: "square.and.arrow.up"), handler: { _ in
                    print("Поделиться")
                }),
                UIAction(title: "Удалить", image: UIImage(systemName: "trash"), attributes: .destructive, handler: { _ in
                    print("Удалить")
                })
            ])
        }
    }
}
