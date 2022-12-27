//
//  EditViewController.swift
//  WeatherApp
//
//  Created by Adem Tarhan on 14.12.2022.
//

import UIKit

protocol EditViewController: AnyObject {
    func editEvent(with event: EventModel)
    var presenter: EditPresenter? { get set }
    var event: EventModel? { get set }
}

class EditViewControllerImpl: UIViewController, EditViewController, UITextFieldDelegate, UITextViewDelegate {
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var eventTitleLabel: UITextField!
    @IBOutlet var updateDescriptionLabel: UITextView!

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!

    var presenter: EditPresenter?
    var eventID: String?
    var datePickerValue: String?
    var event: EventModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        eventTitleLabel.delegate = self
        updateDescriptionLabel.delegate = self

        if let event {
            editEvent(with: event)
        }
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
        }
    }

    @IBAction func didTapUpdate(_ sender: Any) {
        presenter?.updateEvent(date: datePickerValue ?? "", title: eventTitleLabel.text ?? "", description: updateDescriptionLabel.text ?? "", eventID: event?.eventID ?? "")
    }
}

extension EditViewControllerImpl {
    func editEvent(with event: EventModel) {
        eventID = event.eventID
        dlog(self, "event info : \(event)")
        DispatchQueue.main.async {
            self.titleLabel.text = event.title
            self.descriptionLabel.text = event.description
            self.dateLabel.text = event.date
        }
    }
}
