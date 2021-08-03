//
//  UsersViewController.swift
//  Restorev
//
//  Created by Avismara Hugoppalu on 03/08/21.
//

import UIKit

class UsersViewController: UIViewController, LoadingIndicatable, MessageDisplayable {
    var viewModel: UsersViewModel!
    
    @IBOutlet var usersTableView: UITableView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.usersTableView.alpha = 0.0
        self.bind()
        self.viewModel.getUsers()
    }
    
    private func setupTableView() {
        self.usersTableView.delegate = self
        self.usersTableView.dataSource = self
        self.usersTableView.register(UserTableViewCell.nib, forCellReuseIdentifier: UserTableViewCell.cellIdentifier)
    }
    
    private func bind() {
        self.viewModel.didGetUsers = {
            self.hideLoading()
            self.usersTableView.reloadData()
            UIView.animate(withDuration: Constants.ANIMATION_TIME) {
                self.usersTableView.alpha = 1.0
            }
        }
        
        self.viewModel.didGetUsersFail = { error in
            self.hideLoading()
            self.showError(with: Strings.failure, message: error.displayString)
        }
    }
}

extension UsersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfUsers
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.cellIdentifier) as! UserTableViewCell
        cell.nameLabel.text = self.viewModel.userName(at: indexPath.row)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16
    }
}

extension UsersViewController: UserTableViewCellDelegate {
    func didTapEditButtonIn(userTableViewCell: UserTableViewCell) {
        let indexPath = self.usersTableView.indexPath(for: userTableViewCell)!
        Log.d("\(self.viewModel.userId(at: indexPath.row))")
    }
}
