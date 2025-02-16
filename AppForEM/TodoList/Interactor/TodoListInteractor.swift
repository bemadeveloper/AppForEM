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
    var taskArray = [Notes]()
    
    // MARK: - Coredata
    private let coredataManager = CoreDataManager.shared
    
    func fetchTodos() {
        apiService.loadFromServer( completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let jsonData):
                DispatchQueue.main.async {
                    self.coredataManager.saveTodos(from: jsonData)
                    
                    self.taskArray = self.coredataManager.fetchTodosCoreData() ?? [Notes]()
                    self.presenter?.didFetchTodos(self.taskArray)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presenter?.didFailWithError(error)
                }
            }
        })
    }
    
    func update(taskId: Int64, newDescription: String, newData: Data, newTodoTask: String) {
        coredataManager.updateTask(for: taskId, newDescription: newDescription, newData: newData, newTodoTask: newTodoTask)
        
        presenter?.didUpdateTaskSuccessfully()
    }
    
    func deleteAllTodos() {
        coredataManager.deleteAllTodos()
        presenter?.didFetchTodos([])
    }
}
