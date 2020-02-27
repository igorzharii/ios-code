import Foundation
import UIKit

class SearchDataProvider: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var controller: UIViewController?
    var tableView: UITableView?
    var viewModel: SearchViewModel = SearchViewModel()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.separatorColor = viewModel.cells.count == 1 ? .clear : nil
        return viewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = viewModel.cells[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellData.type.value)! as! BaseCell
        configCell(cell, cellData)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch viewModel.cells[indexPath.row].type {
        case .loadingCell, .headerCell:
            return 78
        case .songCell, .autocompleteCell:
            return 86
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        controller?.view.endEditing(true)
        guard viewModel.cells[indexPath.row].song?.autocompleteType == .artist else { return }
        
        searchAllSongs(artist: viewModel.cells[indexPath.row].song!.artist)
    }
    
    func configCell(_ cell: BaseCell, _ cellData: SearchCellData) {
        switch cellData.type {
        case .loadingCell:
            cell.configure()
        case .songCell, .autocompleteCell:
            cell.configure(song: cellData.song!, delegate: self, list: viewModel.list)
        case .headerCell:
            cell.configure(text: cellData.text!)
        }
    }
}

extension SearchDataProvider: SongCellDelegate {
    
    func addSongToList(_ song: RadioSong) {
        Fetcher().toggleSongInSetList(song: song, setListIndex: viewModel.list.index, completion: { error, success in
            
        })
    }
    
    func deleteSongFromList(_ song: RadioSong) {
        Fetcher().toggleSongInSetList(song: song, setListIndex: viewModel.list.index, completion: { error, success in
            
        })
    }
    
    func startSearch(_ type: SearchType) {
        viewModel.startSearch(type)
    }
    
    func endSearch() {
        viewModel.loading = false
        tableView?.reloadData()
        if viewModel.cells.count > 0 {
            tableView?.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
    
    func searchAutocomplete(text: String) {
        startSearch(.autocomplete)
        Fetcher().autocomplete(query: text) { (error, autocompletes) in
            if error == nil {
                self.viewModel.autocompletes = autocompletes
                self.endSearch()
            }
        }
    }
    
    func searchTopSongs() {
        startSearch(.topSongs)
        Fetcher().topsongs(query: "query", completion: { (error, topSongs) in
            self.viewModel.topSongs = topSongs
            self.endSearch()
        })
    }
    
    func searchAllSongs(artist: String) {
        startSearch(.allSongs)
        Fetcher().allSongs(artist: artist, completion: { (error, allSongs) in
            if allSongs.count > 0 {
                self.viewModel.allSongs = allSongs
                self.endSearch()
            } else {
                self.startSearch(.recommendations)
                Fetcher().recommendations(artist: artist, completion: { (error, recommendations) in
                    if recommendations.count > 0 {
                        self.viewModel.recommendations = recommendations
                    } else {
                        self.startSearch(.noResult)
                    }
                    self.endSearch()
                })
            }
        })
    }
}
