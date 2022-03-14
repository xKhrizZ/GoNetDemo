//
//  HomeViewController.swift
//  GoNetDemo
//
//  Created by Christian Rojas on 16/02/22.
//

import UIKit

import iOSSecurity
import iOSBusinessDomain
import iOSDataPersistence


class HomeViewController: UIViewController {
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var headerTableImage: UIImageView!
    @IBOutlet weak var logoNavBarItem: UIBarButtonItem!
    var movies: Movies? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoNavBarItem.image = UIImage(named: "netflixLogo")?
            .withRenderingMode(.alwaysOriginal)
            .withAlignmentRectInsets(UIEdgeInsets(top: 0, left: (self.view.frame.size.width / 4)*(-1), bottom: 0, right: 0))
        
        isOfflineMovie()
        
    }
    
    func isOfflineMovie() {
        NetworkMonitorController.shared.CheckNetworkConnection() { [self] isOnline in
            if !isOnline {
                if (CoreDataManager.shared?.fetchMovieCount() == 0){
                    showAlert(title: BusinessDomainManager.msgAtention, message: BusinessDomainManager.msgNoCatalogStorage, action: BusinessDomainManager.actionClick)
                }
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        //navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MovieTableViewCell
        cell.cellDelegate = self
        cell.setUp(idSection: indexPath.section)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return BusinessDomainManager.sections.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 270
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return BusinessDomainManager.sections[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = .systemFont(ofSize: 22, weight: .bold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text?.capitalized
    }
}

extension HomeViewController: MovieTableViewCellDelegate {
    func launchVC(movieDetail: Results) {
        let storyboard = UIStoryboard.init(name: "HomeStoryboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        vc.movieDetail = movieDetail
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func showAlert(title: String, message: String, action: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: action, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
