//
//  EditViewController.swift
//  AppForEM
//
//  Created by Bema on 10/2/25.
//

import UIKit

class EditViewController: UIViewController {
    
    var task: Notes?
    var onSave: ((Notes) -> Void)?
    private let presenterEditVC: TodoListPresenter
    
    // MARK: - Init
    
    init(presenter: TodoListPresenterInput) {
        self.presenterEditVC = presenter as! TodoListPresenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        return label
    }()
    
    private lazy var titleTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    // MARK: - LyfeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Назад", style: .plain, target: self, action: #selector(backButtonTapped))
        
        setupHierarchy()
        setupLayout()
        loadData()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
    }
    
    
    // MARK: - Setups
    
    private func setupHierarchy() {
        view.addSubview(descriptionTextView)
        view.addSubview(dateLabel)
        view.addSubview(titleTextView)
    }
    
    private func setupLayout() {
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.greaterThanOrEqualTo(60).priority(.required)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionTextView.snp.bottom).offset(16)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        titleTextView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func loadData() {
        guard let task = task else { return }
        descriptionTextView.text = task.descriptionOfTask
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        dateLabel.text = formatter.string(from: task.date ?? Date())
        titleTextView.text = task.todo
    }
    // MARK: - Navigation

    private func saveChanges() {
        guard let task = task else { return }
        task.descriptionOfTask = descriptionTextView.text
        task.todo = titleTextView.text
        task.date = Date()
        
        onSave?(task)
        
        do {
            try presenterEditVC.update(taskId: task.id, newDescription: descriptionTextView.text, newData: Data(), newTodoTask: titleTextView.text)
        } catch {
            print("Ошибка сохранения: \(error.localizedDescription)")
        }
    }
    
    @objc private func backButtonTapped() {
        saveChanges()
        navigationController?.popViewController(animated: true)
    }
    

}

extension EditViewController: UITextViewDelegate {
//    func textViewDidChange(_ textView: UITextView) {
//        let maxHeight: CGFloat = textView == titleTextView ? 60 : 200 // Заголовок макс. 60, описание макс. 200
//        let size = CGSize(width: textView.frame.width, height: .greatestFiniteMagnitude)
//        let estimatedSize = textView.sizeThatFits(size)
//        
//        textView.isScrollEnabled = estimatedSize.height > maxHeight
//        
//        textView.snp.remakeConstraints { make in
//            make.leading.trailing.equalToSuperview().inset(10)
//            make.height.equalTo(min(max(40, estimatedSize.height), maxHeight))
//            
//            if textView == descriptionTextView {
//                make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
//            } else {
//                make.top.equalTo(dateLabel.snp.bottom).offset(6)
//                make.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
//            }
//        }
//        
//        UIView.animate(withDuration: 0.2) {
//            self.view.layoutIfNeeded()
//        }
//    }
}
