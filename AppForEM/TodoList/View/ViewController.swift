//
//  ViewController.swift
//  AppForEM
//
//  Created by Bema on 5/2/25.
//

import UIKit
import SnapKit
import Speech

class ViewController: UIViewController, UISearchBarDelegate {
    
    private let presenter: TodoListPresenterInput
    var todos: [Todo] = []
    
    private let searchBar = UISearchBar()
    
    // MARK: - Init
    
    init(presenter: TodoListPresenterInput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lyfecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        NotificationCenter.default.addObserver(self, selector: #selector(todosUpdated), name: NSNotification.Name("TodosUpdated"), object: nil)
        setupUI()
        loadAndSaveTodos()
    }
    
    // MARK: - TableView
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(CustomTaskCell.self, forCellReuseIdentifier: CustomTaskCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isOpaque = true
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    // MARK: - Setups
    
    private func setupUI() {
        view.backgroundColor = UIColor.systemGroupedBackground
        setupCustomTitle()
        setupSearchBar()
        
        setupHierarchy()
        setupLayout()
        
        todos = CoreDataManager.shared.fetchTodosCoreData()
    }
    
    private func setupCustomTitle() {
        let containerView = UIView()
        
        let titleLabel = UILabel()
        titleLabel.text  = "Задачи"
        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        titleLabel.textColor = UIColor.label
        titleLabel.textAlignment = .left
        
        containerView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        let leftBarButtonItem = UIBarButtonItem(customView: containerView)
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    private func setupSearchBar() {
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupHierarchy() {
        view.addSubview(tableView)
        view.addSubview(searchBar)
    }
    
    private func setupLayout() {
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(45)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10) 
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Поиск: \(searchText)")
    }

    @objc private func todosUpdated() {
        todos = CoreDataManager.shared.fetchTodosCoreData()
        tableView.reloadData()
    }

    func loadAndSaveTodos() {
        APIService.shared.fetchTodos { result in
            switch result {
            case .success(let jsonData):
                DispatchQueue.main.async {
                    CoreDataManager.shared.saveTodos(from: jsonData)
                }
                
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
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTaskCell.identifier, for: indexPath) as? CustomTaskCell else {
            return UITableViewCell()
        }
        
        let todo = todos[indexPath.row]
        cell.configure(with: todo)
        
        cell.onDoneMarkTapped = { [weak self] in
            self?.toggleCompleted(at: indexPath)
        }
        return cell
    }
    
    private func toggleCompleted(at indexPath: IndexPath) {
        let todo = todos[indexPath.row]
        todo.completed.toggle()
        
        do {
            try CoreDataManager.shared.context.save()
            tableView.reloadRows(at: [indexPath], with: .automatic)
        } catch {
            print("Ошибка при обновлении задачи: \(error)")
        }
    }
}

extension ViewController: TodoListPresenterOutput {
    func displayTodos(_ todos: [Todo]) {
        self.todos = todos
        tableView.reloadData()
    }
    
    func displayError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
