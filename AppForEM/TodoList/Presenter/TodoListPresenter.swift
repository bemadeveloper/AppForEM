//
//  TodoListPresenter.swift
//  AppForEM
//
//  Created by Bema on 6/2/25.
//

import Foundation

class TodoListPresenter: TodoListPresenterInput {
    weak var view: TodoListPresenterOutput?
    private let interactor: TodoListInteractorInput
    
    init(interactor: TodoListInteractorInput) {
        self.interactor = interactor
    }
    
    func loadTodos() {
        interactor.fetchTodos()
    }
    
    func deleteTodos() {
        interactor.deleteAllTodos()
    }
}

extension TodoListPresenter: TodoListInteractorOutput {
    func didFetchTodos(_ todos: [Notes]) {
        view?.displayTodos(todos)
    }
    
    func didFailWithError(_ error: any Error) {
        view?.displayError(error.localizedDescription)
    }
    
    
}
