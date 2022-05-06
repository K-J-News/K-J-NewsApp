//
//  FeedViewController.swift
//  K & J News
//
//  Created by Justin Le on 4/7/22.
//

import UIKit
import SafariServices
import Parse
import Foundation


//TableView
//CustomCell
//APICall
//Open the News Story
//Search for news Story (Other Tab)

class FeedViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    

    @IBOutlet weak var feedNavBar: UINavigationItem!
    
    private var previousCategory = ""
    
    private var noResultsLabel: UILabel!
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        return table
    }()
    
    private var articles = [Article]()
    private var viewModels = [NewsTableViewCellViewModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.view.backgroundColor = UIColorFromHex(rgbValue: 0x323232,alpha: 1)
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        noResultsLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
        noResultsLabel.center = CGPoint(x: 210, y: 285)
        noResultsLabel.textColor = UIColor.gray
        noResultsLabel.textAlignment = .center
        noResultsLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        noResultsLabel.numberOfLines = 0
        noResultsLabel.text = "No results. Please try again later."
        noResultsLabel.isHidden = true
        self.view.addSubview(noResultsLabel)
        //noResultsLabel.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let user = PFUser.current()!
        let userCountry = user["country"]! as! String
        let userLang = user["lang"]! as! String
        
        let menuHandler: UIActionHandler = { action in
            print(action.title)
            self.feedNavBar.title = action.title
            self.previousCategory = action.title
            
            //feed view updates when user selects a new category
            APICaller.shared.getUserCategoryStories(lang: userLang, country: userCountry, category: action.title) {
                [weak self] result in
                        switch result {
                        case .success(let articles):
                            self?.articles = articles
                            self?.viewModels = articles.compactMap({
                                NewsTableViewCellViewModel(title: $0.title,
                                                           subtitle: $0.description ?? "No description",
                                                           imageURL: URL(string: $0.urlToImage ?? ""))
                            })
                            DispatchQueue.main.async {
                                if(articles.count == 0){
                                    self?.noResultsLabel.isHidden = false
                                } else{
                                    self?.noResultsLabel.isHidden = true
                                }

                                self?.tableView.reloadData()
                                
                            }
                        case .failure(let error):
                            print(error)
                        }
                    }
        }

        let barButtonMenu = UIMenu(title: "", children: [
            UIAction(title: NSLocalizedString("Business", comment: ""),  handler: menuHandler),
            UIAction(title: NSLocalizedString("Entertainment", comment: ""),  handler: menuHandler),
            UIAction(title: NSLocalizedString("General", comment: ""), handler: menuHandler),
            UIAction(title: NSLocalizedString("Health", comment: ""), handler: menuHandler),
            UIAction(title: NSLocalizedString("Science", comment: ""), handler: menuHandler),
            UIAction(title: NSLocalizedString("Sports", comment: ""), handler: menuHandler),
            UIAction(title: NSLocalizedString("Technology", comment: ""), handler: menuHandler)
        ])

        feedNavBar.rightBarButtonItem = UIBarButtonItem(title: "Categories", style: .plain, target: self, action: nil)
        feedNavBar.rightBarButtonItem?.menu = barButtonMenu
        if (previousCategory == ""){
            
        
        //default feed when app first opens
        APICaller.shared.getUserTopStories(lang: userLang, country: userCountry) {
            [weak self] result in
                    switch result {
                    case .success(let articles):
                        self?.articles = articles
                        self?.viewModels = articles.compactMap({
                            NewsTableViewCellViewModel(title: $0.title,
                                                       subtitle: $0.description ?? "No description",
                                                       imageURL: URL(string: $0.urlToImage ?? ""))
                        })
                        DispatchQueue.main.async {
                            if(articles.count == 0){
                                self?.noResultsLabel.isHidden = false
                            } else{
                                self?.noResultsLabel.isHidden = true
                            }
                            self?.tableView.reloadData()
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
        } else{
            //feed gets the previous selected category
            APICaller.shared.getUserCategoryStories(lang: userLang, country: userCountry, category: previousCategory) {
                [weak self] result in
                        switch result {
                        case .success(let articles):
                            self?.articles = articles
                            self?.viewModels = articles.compactMap({
                                NewsTableViewCellViewModel(title: $0.title,
                                                           subtitle: $0.description ?? "No description",
                                                           imageURL: URL(string: $0.urlToImage ?? ""))
                            })
                            DispatchQueue.main.async {
                                if(articles.count == 0){
                                    self?.noResultsLabel.isHidden = false
                                } else{
                                    self?.noResultsLabel.isHidden = true
                                }
                                self?.tableView.reloadData()
                            }
                        case .failure(let error):
                            print(error)
                        }
                    }
        }
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
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
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView,cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NewsTableViewCell.identifier,
            for:indexPath
        ) as? NewsTableViewCell else {
            fatalError()
        }
        cell.configure(with: viewModels[indexPath.row])
        return cell
        
        if (indexPath.row % 2 == 0){
            cell.backgroundColor = UIColor.blue;
        } else {
            cell.backgroundColor = UIColor.white;
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        let article = articles[indexPath.row]
        
        guard let url = URL(string: article.url ?? "")else{
            return
        }
        
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 150  
    }
    
//    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
//        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
//        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
//        let blue = CGFloat(rgbValue & 0xFF)/256.0
//
//        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
//    }

       
    
   
    
    
    
}

