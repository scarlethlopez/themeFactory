//
//  ViewController.swift
//  BK
//
//  Created by Aylwing Olivas on 11/5/21.
//

import UIKit

struct UserModel: Hashable {
    var name:String!
    var balance:String!
    }

typealias UserDataSource = UITableViewDiffableDataSource<TblSection, UserModel>

typealias UserSnapshot = NSDiffableDataSourceSnapshot<TblSection, UserModel>

class ViewController: UIViewController{
    var arraData = [UserModel]()
    
    @IBOutlet weak var tblView: UITableView!
    
    
    let searchcontroller = UISearchController(searchResultsController: nil)
    var datasource: UserDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.dark.colorBackground
        tblView.backgroundColor = Theme.dark.colorBackground
        self.navigationController?.navigationBar.backgroundColor = Theme.dark.colorBackground
        tblView.allowsSelection = true
        configureDatasource()
        arraData = getAllData()
        createSnapshot(users: arraData)
        addSearchbar()
        tblView.delegate = self
        tblView.dataSource = self
    }
    func configureDatasource(){
        datasource = UserDataSource(tableView: tblView, cellProvider: { (tableView, indexPath, user) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = user.name
            cell.detailTextLabel?.text = user.balance
            cell.backgroundColor = Theme.dark.colorBackground
            return cell
        })
    }

    func getAllData() -> [UserModel]{
        return [UserModel.init(name: "A", balance: "B")]
    }
    

   func addSearchbar() {
        searchcontroller.searchResultsUpdater = self
        searchcontroller.obscuresBackgroundDuringPresentation = false
        searchcontroller.searchBar.placeholder = "Search Users"
        navigationItem.searchController = searchcontroller
        definesPresentationContext = true
    }
    
    @IBAction func btnClick(_ sender: Any) {
        
        let alert = UIAlertController(title: "", message: "Add User", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default) {
            (okTarget) in
            if let txtName = alert.textFields?.first?.text {
                self.addUser(name: txtName)
            }

        }
        alert.addTextField {(txtUser) in
            txtUser.placeholder = "Enter username"
        }
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    func addUser(name: String){
        arraData.append(UserModel(name: name))
        createSnapshot(users: arraData)

    }
    func addBalance(balance: String){
        arraData.append(UserModel(balance: balance))
        createSnapshot(users: arraData)

    }
    
    func createSnapshot(users: [UserModel]) {
        var snapshot = UserSnapshot()
        snapshot.appendSections([.first])
        snapshot.appendItems(users)
        datasource.apply(snapshot, animatingDifferences: true)
    }
}

enum TblSection{
    case first
}


extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchcontroller.searchBar.text
        if searchText == "" {
            arraData = getAllData()
        }else {
            arraData = getAllData().filter{ $0.name.contains(searchText!)}
        }
        createSnapshot(users: arraData)
    }
}


extension ViewController: UITableViewDataSource, UITableViewDelegate {
    private func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arraData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        let data = arraData[indexPath.row]
        

        if let nameA = data.name {
            cell.textLabel?.text = nameA
        }
        
        if let nameB = data.balance {
            cell.detailTextLabel?.text = nameB
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tblView.beginUpdates()
            arraData.remove(at: indexPath.row)
            tblView.deleteRows(at: [indexPath], with: .fade)
            tblView.endUpdates()
        }
    }
   func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
            return .delete
        }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let alert = UIAlertController(title: "", message: "Add User", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default) {
            (okTarget) in
            if let txtName = alert.textFields?.first?.text {
                self.addBalance(balance: txtName)
            }

        }
        alert.addTextField {(txtUser) in
            txtUser.placeholder = "Enter username"
        }
        alert.addAction(ok)
            present(alert, animated: true)
            
    }
    
}


