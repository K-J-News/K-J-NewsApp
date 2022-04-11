//
//  FeedViewController.swift
//  K & J News
//
//  Created by Justin Le on 4/7/22.
//

import UIKit

//TableView
//CustomCell
//APICall
//Open the News Story
//Search for news Story (Other Tab)

class FeedViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        APICaller.shared.getTopStories { result in
            switch result {
            case .success(let response):
                break
            case .failure(let error):
                print(error)
            }
        }

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func tableView(_ tableView: UITableView,numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView,cellForRowAt indexPath: IndexPath) -> Int {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell",
            for:indexPath
        )
        cell.textLabel?.text = "Something"
        return cell
    }
    
}

