//
//  TodoListInteractor.swift
//  AppForEM
//
//  Created by Bema on 6/2/25.
//

import Foundation

class TodoListInteractor: TodoListInteractorInput {
    
    weak var output: TodoListPresenterOutput?
    weak var presenter: TodoListInteractorOutput?
    private let apiService = APIService.shared
    
    // MARK: - Coredata
    private let coredataManager = CoreDataManager.shared
    
    func fetchTodos() {
        apiService.loadFromServer( completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let jsonData):
                DispatchQueue.main.async {
                    self.coredataManager.saveTodos(from: jsonData)
                    let todos = self.coredataManager.fetchTodosCoreData()
                    self.presenter?.didFetchTodos(todos)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presenter?.didFailWithError(error)
                }
            }
        })
    }
    
    func deleteAllTodos() {
        coredataManager.deleteAllTodos()
        presenter?.didFetchTodos([])
    }
}
