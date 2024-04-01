//
//  FeedViewController.swift
//  SportsMeetups
//
//  Created by Chelsea Garcia on 3/24/24.
//

import UIKit
import ParseSwift

class FeedViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! // this needs to be implemented in the storybord
    private let refreshControl = UIRefreshControl()
     
     
     private var posts = [Post]() {
         didSet {
             tableView.reloadData()
         }
     }
     
         override func viewDidLoad() {
         super.viewDidLoad()
         tableView.delegate = self
         tableView.dataSource = self
         tableView.allowsSelection = false
         
         tableView.refreshControl = refreshControl
         refreshControl.addTarget(self, action: #selector(onPullToRefresh), for: .valueChanged)
     }

     override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)

         queryPosts()
     }

     private func queryPosts(completion: (() -> Void)? = nil) {
         let yesterdayDate = Calendar.current.date(byAdding: .day, value: (-1), to: Date())!
         
         let query = Post.query()
             .include("user")
             .order([.descending("createdAt")])
             .where("createdAt" >= yesterdayDate)
             .limit(10)
         
         query.find { [weak self] result in
             switch result {
             case .success(let posts):
                 self?.posts = posts
             case .failure(let error):
                 self?.showAlert(description: error.localizedDescription)
             }
             completion?()
         }
     }

     @objc private func onPullToRefresh() {
         refreshControl.beginRefreshing()
         queryPosts { [weak self] in
             self?.refreshControl.endRefreshing()
         }
     }
 }


extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell else {
            return UITableViewCell()
        }
        cell.configure(with: posts[indexPath.row])
        print("are you getting inside tableview?")
        return cell
    }
}
extension FeedViewController: UITableViewDelegate { }
