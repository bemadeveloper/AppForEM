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
    
    private let presenter: TodoListPresenter
    var todos: [Notes] = []
    
    private let searchBar = UISearchBar()
    
    // MARK: - Init
    
    init(presenter: TodoListPresenterInput) {
        self.presenter = presenter as! TodoListPresenter
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
        presenter.deleteTodos()
        presenter.loadTodos()
    }
    
    // MARK: - UI
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(CustomTaskCell.self, forCellReuseIdentifier: CustomTaskCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorColor = .gray
        tableView.isOpaque = true
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapPlusButton), for: .touchUpInside)
        button.tintColor = .yellow
        
        return button
    }()
    
    // MARK: - Setups
    
    private func setupUI() {
        view.backgroundColor = UIColor.systemGroupedBackground
        setupCustomTitle()
        setupSearchBar()
        
        setupHierarchy()
        setupLayout()
    }
    
    private func setupCustomTitle() {
        let containerView = UIView()
        
        let titleLabel = UILabel()
        titleLabel.text  = "Задачи"
        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        titleLabel.textColor = UIColor.label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .left
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, plusButton])
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        
        containerView.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }

        containerView.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width - 32)
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
            make.height.lessThanOrEqualTo(45)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10) 
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Поиск: \(searchText)")
    }

    private var isUpdating = false
    
    @objc private func todosUpdated() {
        guard !isUpdating else { return }
            isUpdating = true
        
        tableView.reloadData()
        
    }
    
    
    @objc func didTapPlusButton() {
        print("Tap")
        let addViewController = DetailViewController(presenter: presenter)
        addViewController.modalPresentationStyle = .fullScreen
        present(addViewController, animated: true)
    }


    
//    func loadAndSaveTodos() {
//        APIService.shared.loadFromServer(completion: { result in
//            switch result {
//            case .success(let jsonData):
//                DispatchQueue.main.async {
//                    CoreDataManager.shared.saveTodos(from: jsonData)
//                }
//                
//                DispatchQueue.main.async {
//                    self.todos = CoreDataManager.shared.fetchTodosCoreData(context: CoreDataManager.shared.context)
//                    self.tableView.reloadData()
//                }
//            case .failure(let error):
//                DispatchQueue.main.async {
//                    print("Ошибка загрузки -> \(error)")
//                }
//            }
//        })
//    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.rowHeight = UITableView.automaticDimension
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedCell = todos[indexPath.row]
        let editVC = EditViewController(presenter: presenter)
        editVC.task = selectedCell
        
        editVC.onSave = { [weak self] updatedTodo in
            self?.todos[indexPath.row] = updatedTodo
            self?.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        navigationController?.pushViewController(editVC, animated: true)
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
   
    
    func displayTodos(_ todos: [Notes]) {
        self.todos = todos
        tableView.reloadData()
    }
    
    func displayError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
