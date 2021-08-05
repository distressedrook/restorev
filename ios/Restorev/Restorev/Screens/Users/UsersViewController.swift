//
//  UsersViewController.swift
//  Restorev
//
//  Created by Avismara Hugoppalu on 03/08/21.
//

import UIKit
import DZNEmptyDataSet

class UsersViewController: UIViewController, LoadingIndicatable, MessageDisplayable {
    var viewModel: UsersViewModel!
    var router: UsersRouter!
    let refreshControl = UIRefreshControl()
    
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
        self.usersTableView.emptyDataSetSource = self
        self.usersTableView.emptyDataSetDelegate = self
        self.refreshControl.tintColor = UIColor.brandBlue
        self.refreshControl.addTarget(self, action: #selector(UsersViewController.getUsers(sender:)), for: .valueChanged)
        self.usersTableView.addSubview(refreshControl)
    }
    
    private func bind() {
        self.viewModel.didGetUsers = {
            self.refreshControl.endRefreshing()
            self.hideLoading()
            self.usersTableView.reloadData()
            UIView.animate(withDuration: Constants.ANIMATION_TIME) {
                self.usersTableView.alpha = 1.0
            }
        }
        
        self.viewModel.didGetUsersFail = { error in
            self.refreshControl.endRefreshing()
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
        let userId = self.viewModel.userId(at: indexPath.row)
        router.moveToEditUserWith(userId: userId, delegate: self)
    }
}

extension UsersViewController: EditUserViewControllerDelegate {
    func didCompleteActionIn(editUserViewController: EditUserViewController) {
        self.showLoading()
        self.viewModel.getUsers()
    }
    
    @objc func getUsers(sender: AnyObject?) {
        self.viewModel.getUsers()
    }
}

extension UsersViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return UIImage.confusedBanner
    }
    
    func spaceHeight(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return 24.0
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let font = UIFont.openSansSemiBold(with: 21)
        let color = UIColor.neutralBlack.withAlphaComponent(0.2)
        let attributes = [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: font]
        return NSAttributedString(string: Strings.noUsers, attributes: attributes)
    }
}
