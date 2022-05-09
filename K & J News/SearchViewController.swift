//
//  SearchViewController.swift
//  K & J News
//
//  Created by Justin Le on 4/9/22.
//

import UIKit
import SafariServices
import Parse

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    private let tableView: UITableView = {
        let table = UITableView()
        table.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        return table
    }()
    
    private let searchVC = UISearchController(searchResultsController: nil)
    private var noResultsLabel: UILabel!
    private var articles = [Article]()
    private var viewModels = [NewsTableViewCellViewModel]()
    
    
    override func viewDidAppear(_ animated: Bool) {
        let user = PFUser.current()!
        let userCountry = user["country"]! as! String
        let userLang = user["lang"]! as! String
        APICaller.shared.getUserTopStories(lang: userLang, country: userCountry){ [weak self] result in
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        createSearchBar()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func createSearchBar(){
        navigationItem.searchController = searchVC
        searchVC.searchBar.delegate = self
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
    
    //Search
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else{
            return
        }
        let user = PFUser.current()!
        let userCountry = user["country"]! as! String
        let userLang = user["lang"]! as! String
        APICaller.shared.getUserSearch(lang: userLang, country: userCountry, query: text) {
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
                        self?.searchVC.dismiss(animated: true, completion: nil)
                    }
                case .failure(let error):
                    print(error)
                    print("search term accepted/ran")
                }
            }
        }
       
    }


