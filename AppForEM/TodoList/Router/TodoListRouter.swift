//
//  TodoListRouter.swift
//  AppForEM
//
//  Created by Bema on 6/2/25.
//

import Foundation
import UIKit

class TodoListRouter {
    static func createModule() -> UIViewController {
        let interactor = TodoListInteractor()
        let presenter = TodoListPresenter(interactor: interactor)
        let view = ViewController(presenter: presenter)
        
        presenter.view = view
        interactor.presenter = presenter as! any TodoListInteractorOutput
        
        return view
        
    }
}
