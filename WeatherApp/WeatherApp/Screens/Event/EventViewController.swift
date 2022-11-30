//
//  EventViewController.swift
//  WeatherApp
//
//  Created by Adem Tarhan on 27.11.2022.
//

import UIKit

protocol EventViewController: AnyObject {
    var presenter: EventPresenter? {get set}
}

class EventViewControllerImpl: UIViewController, EventViewController, UITextFieldDelegate,UITextViewDelegate {
    var presenter: EventPresenter?
    @IBOutlet var titleLabel: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var descriptionLabel: UITextView!
    
    var datePickerValue : String?

    override func viewDidLoad() {
        super.viewDidLoad()

        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        titleLabel.delegate = self
        descriptionLabel.delegate = self
    }

    @IBAction func didTapSaveEventButton(_ sender: Any) {
        presenter?.saveEvent(date: datePickerValue ?? "", title: titleLabel.text ?? "", description: descriptionLabel.text)
    }

    @objc func keyboardWillShow(sender: NSNotification) {
        datePicker.layer.opacity = 0.0
        view.frame.origin.y = -200
    }

    @objc func keyboardWillHide(sender: NSNotification) {
        datePicker.layer.opacity = 1.0
        view.frame.origin.y = 0
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }

    @objc func dateChanged(_ sender: UIDatePicker) {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: sender.date)
        if let day = components.day, let month = components.month, let year = components.year {
            datePickerValue = "\(day) \(month) \(year)"
            print("\(day) \(month) \(year)")
        }
    }
}
