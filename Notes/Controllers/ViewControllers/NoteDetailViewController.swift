//
//  NoteDetailViewController.swift
//  Notes
//
//  Created by Devin Ghumman on 1/10/20.
//  Copyright © 2020 Devin Ghumman. All rights reserved.
//

import UIKit

class NoteDetailViewController: UIViewController{
    
    // MARK: - Variables
    var note: Note?

    // MARK: - Outlets
    @IBOutlet weak var bodyTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        if let note = self.note, let bodyText = bodyTextView.text{
            NoteController.sharedInstance.update(note: note, withBodyText: bodyText)
              }else{
                guard let bodyText = bodyTextView.text else { return }
                NoteController.sharedInstance.addNote(withBodyText: bodyText)
              }
              navigationController?.popViewController(animated: true)
    }
    
    func updateViews() {
        if let note = self.note {
            bodyTextView.text = note.bodyText
        }
    }
}
