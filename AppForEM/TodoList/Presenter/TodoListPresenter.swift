//
//  TodoListPresenter.swift
//  AppForEM
//
//  Created by Bema on 6/2/25.
//

import Foundation

class TodoListPresenter: TodoListPresenterInput {
    weak var view: TodoListPresenterOutput?
    private let interactor: TodoListInteractor
    
    init(interactor: TodoListInteractor) {
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
    func didUpdateTaskSuccessfully() {
    }
    
    func didFetchTodos(_ todos: [Notes]) {
        view?.displayTodos(todos) 
        
    }
    
    func didFailWithError(_ error: any Error) {
        view?.displayError(error.localizedDescription)
    }
    
    
}
