//
//  ViewController.swift
//  AppForEM
//
//  Created by Bema on 5/2/25.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    var todos: [Todo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupHierarchy()
        setupLayout()
        loadAndSaveTodos()
    }
    
    // MARK: - TableView
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TodoCell")
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    func loadAndSaveTodos() {
        APIService.shared.fetchTodos { result in
            switch result {
            case .success(let jsonData):
                CoreDataManager.shared.saveTodos(from: jsonData)
                
                DispatchQueue.main.async {
                    self.todos = CoreDataManager.shared.fetchTodosCoreData()
                    self.tableView.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print("Ошибка загрузки -> \(error)")
                }
            }
        }
    }
    
    private func setupHierarchy() {
        view.addSubview(tableView)
    }
    
    private func setupLayout() {
        tableView.snp.makeConstraints { make in
            make.left.top.right.bottom.equalToSuperview()
        }
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        let todo = todos[indexPath.row]
        cell.textLabel?.text = todo.todo
        return cell
    }
    
    
}
