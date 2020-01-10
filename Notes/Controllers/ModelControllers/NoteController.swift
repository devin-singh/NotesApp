//
//  NoteController.swift
//  Notes
//
//  Created by Devin Ghumman on 1/10/20.
//  Copyright © 2020 Devin Ghumman. All rights reserved.
//

import Foundation

class NoteController {
    /// Array of Note objects to be loaded onto the tableview
    var notes: [Note] = []
    // Singleton
    static let sharedInstance = NoteController()
    
    func addNote(withBodyText bodyText: String) {
        let note = Note(bodyText: bodyText)
        notes.append(note)
        saveToPersistantStore()
    }
    
    func remove(note: Note) {
        if let index = notes.firstIndex(of: note) {
            notes.remove(at: index)
            saveToPersistantStore()
        }
    }
    
    func update(note: Note, withBodyText bodyText: String) {
        if let index = notes.firstIndex(of: note) {
            notes[index].bodyText = bodyText
            saveToPersistantStore()
        }
    }
    
     // MARK: - Persistence
    func createFileForPersistence() -> URL {
        // Grab the users Document directory
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        // Create the new fileURL on the users Phone
         let fileUrl = urls[0].appendingPathComponent("Notes.json")
         return fileUrl
     }
    
    func saveToPersistantStore() {
        // Create an instance of JSONEncoder
        let jsonEncoder = JSONEncoder()
        // Attempt to convert our playlist array into JSON
        // Anytime a method throws, it must be placed in a do, try, catch block
        do {
            let jsonEntries = try jsonEncoder.encode(notes)
            // With the new JSON(d) playlist arraay, save it to the users device
            try jsonEntries.write(to: createFileForPersistence())
        } catch let encodingError {
            print("There was an error saving the data! \(encodingError)")
        }
    }
    
    func loadFromPersistentStorage() {
        let jsonDecoder = JSONDecoder()
        do {
            let jsonData = try Data(contentsOf: createFileForPersistence())
            let decodedPlaylists = try jsonDecoder.decode([Note].self, from: jsonData)
            notes = decodedPlaylists
        } catch let decodingError {
            print("Error loading data \(decodingError)")
        }
    }
}
