//
//  TableViewCell.swift
//  GoNetDemo
//
//  Created by Christian Rojas on 17/02/22.
//

import UIKit
import iOSApiRest
import iOSBusinessDomain
import iOSSecurity
import iOSDataPersistence

protocol MovieTableViewCellDelegate {
    func launchVC(movieDetail: Results)
    func showAlert(title: String, message: String, action: String)
}

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var carrouselCollectionView: UICollectionView!
    let Loader = LoaderView()
    var movies: Movies?
    var networkManger : URL_Session?
    var cellDelegate : MovieTableViewCellDelegate? = nil
    var idSection: Int?
    
    internal func setUp(idSection: Int?){
        print("setupSection: \(idSection)")
        self.idSection = idSection
        loadServices(idSection: idSection)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.carrouselCollectionView.dataSource = self
        self.carrouselCollectionView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    private func loadServices(idSection: Int?) {
        guard idSection != nil else {
            print("No se pudo obtener valor del id de seccion")
            return
        }
        
        NetworkMonitorController.shared.CheckNetworkConnection() { [self] isOnline in
            isOnline ? catalogMovieOnline(idSection: idSection) : catalogMovieOffline(idSection: idSection)
        }
        
        Loader.showActivityIndicatory(uiView: self)
    }
    
    private func catalogMovieOnline(idSection: Int?) {
        networkManger = URL_Session()
        networkManger?.delegate = self

        switch idSection {
            case 0:
            networkManger?.getMovieFavorite()
                break
            case 1:
            networkManger?.getMovieRecommendations()
                break
            case 2:
            networkManger?.getMovieRated()
                break
            case 3:
            networkManger?.getTvShowFavorite()
                break
            case 4:
            networkManger?.getTvShowRecommendations()
                break
            case 5:
            networkManger?.getTvShowRated()
                break
            default:
                break
        }
    }
    
    private func catalogMovieOffline(idSection: Int?) {
        print("Entra al caso offline idSection -> \(idSection)")
        
        guard let movieString = CoreDataManager.shared?.fetchMovie(with: idSection!)?.data, !movieString.isEmpty else {
            print("Error el movieString viene vacio no se encontro en la base la seccion cifrada del json")
            return
        }
        
        guard let jsonString = SecurityManager.base64Decrypt(key: BusinessDomainManager.keyCipher, base64: movieString).data(using: .utf8) else {
            print("Error no pudimos obtener el jsonString descifrado")
            return
        }
            
        do {
            let mov = try JSONDecoder().decode(Movies.self, from: jsonString)
            self.movies = mov
            DispatchQueue.main.async {
                self.carrouselCollectionView.reloadData()
            }
        } catch {
            print(error)
        }

    }
}


extension MovieTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies?.results?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CCollectionViewCell
        
        if let img = movies?.results?[indexPath.row].poster_path {
            cell.imageMovie.loadImage(urlStr: "\(BusinessDomainManager.imagePath)\(img ?? "")")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cellDelegate?.launchVC(movieDetail: (movies?.results?[indexPath.item])!)
    }
}


extension MovieTableViewCell: URL_SessionDelegate {
    func connectionFinishSuccessfull(session: URL_Session, response: NSDictionary?) {
        
        switch session {
        case networkManger:
            
            do {
                let responseCoded = try JSONDecoder().decode(Movies.self, from: JSONSerialization.data(withJSONObject: response))
                movies = responseCoded
                carrouselCollectionView.reloadData()
                
                var jsonString : String! {
                    let data = try! JSONEncoder().encode(movies)
                    return String(data: data, encoding: .utf8)!
                }
                
                CoreDataManager.shared?.removeMovie(with: idSection!)
                CoreDataManager.shared?.addMovie(with: idSection!, with: jsonString)
                
            } catch {
                print("Ocurrió un error con la serialización del JSON")
            }
            
            break
        default:
            break
            
        }
        
        Loader.hideActivityIndicator(uiView: self);
    }
    
    func connectionFinishWithError(session: URL_Session, error: Error) {
        Loader.hideActivityIndicator(uiView: self);
    }
}
