//
//  FindDetailViewController.swift
//  Arena
//
//  Created by Vijay Murugappan Subbiah on 6/28/17.
//  Copyright © 2017 Vijay Murugappan Subbiah. All rights reserved.
//

import UIKit
import JTAppleCalendar

class FindDetailViewController: UIViewController {

    let formatter = DateFormatter()
    
    @IBOutlet weak var CalenderView: JTAppleCalendarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CalenderView.ibCalendarDataSource = self
        CalenderView.ibCalendarDelegate = self
    }
}

extension FindDetailViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        let startDate = formatter.date(from: "2017 01 01")
        let endDate = formatter.date(from: "2017 12 31")
        let params = ConfigurationParameters(startDate: startDate!, endDate: endDate!)
        return params
    }
}

extension FindDetailViewController: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCalendarCell
        cell.DateLabel.text = cellState.text
        return cell
    }
    
}
