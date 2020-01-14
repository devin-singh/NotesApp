//
//  NoteListTableViewController.swift
//  Notes
//
//  Created by Devin Singh on 1/10/20.
//  Copyright © 2020 Devin Singh. All rights reserved.
//

import UIKit

class NoteListTableViewController: UITableViewController{
    
    // MARK: - Variables
    var filteredNotes: [Note] = []
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    // MARK: - Outlets
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    // MARK: - Table View Lifecycle functions
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Candies"
        navigationItem.searchController = searchController
        
        definesPresentationContext = true
        NoteController.sharedInstance.loadFromPersistentStorage()
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Actions
    @IBAction func editButtonPressed(_ sender: Any) {
        if editButton.title == "Edit" {
            self.tableView.isEditing = true
            editButton.title = "Done"
        }else{
            self.tableView.isEditing = false
            editButton.title = "Edit"
        }
        
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if isFiltering {
          return filteredNotes.count
        }
        return NoteController.sharedInstance.notes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath)
        // Grabs note to be displayed
        let note: Note?
        if isFiltering {
          note = filteredNotes[indexPath.row]
        } else {
            note = NoteController.sharedInstance.notes[indexPath.row]
        }
        // Sets the current cell title that function is on to correct note
        cell.textLabel?.text = note?.bodyText
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let noteToRemove = NoteController.sharedInstance.notes[indexPath.row]
            NoteController.sharedInstance.remove(note: noteToRemove)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedNote = NoteController.sharedInstance.notes[sourceIndexPath.row]
        NoteController.sharedInstance.remove(note: movedNote)
        NoteController.sharedInstance.notes.insert(movedNote, at: destinationIndexPath.row)
        NoteController.sharedInstance.saveToPersistantStore()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "updateToDetailView" {
            guard let indexPath = tableView.indexPathForSelectedRow, let destinationVC = segue.destination as? NoteDetailViewController else {return}
            let note: Note?
            if isFiltering {
              note = filteredNotes[indexPath.row]
            } else {
              note = NoteController.sharedInstance.notes[indexPath.row]
            }
            
            destinationVC.note = note
        }
        
    }
    
    // MARK: - UISearchResultsUpdating Setup
    // May have error with category param
    func filterContentForSearchText(_ searchText: String, category: Note? = nil) {
        filteredNotes = NoteController.sharedInstance.notes.filter { (note: Note) -> Bool in
            return note.bodyText.lowercased().contains(searchText.lowercased())
      }
      tableView.reloadData()
    }
}

extension NoteListTableViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar
    filterContentForSearchText(searchBar.text!)
  }
}
