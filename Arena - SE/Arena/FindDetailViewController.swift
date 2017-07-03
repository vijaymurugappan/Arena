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
    let outsideMonthColor = UIColor.init(hexColor: 0xF4F5DC)
    let selectedMonthColor = UIColor.white
    let monthColor = UIColor.black
    
    @IBOutlet weak var CalenderView: JTAppleCalendarView!
    @IBOutlet weak var MonthView: UILabel!
    @IBOutlet weak var YearView: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CalenderView.ibCalendarDataSource = self
        CalenderView.ibCalendarDelegate = self
        CalenderView.minimumLineSpacing = 0
        CalenderView.minimumInteritemSpacing = 0
        CalenderView.visibleDates { visibleDates in
            self.setupCalendar(from: visibleDates)
        }
    }
    
    func setupCalendar(from visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first?.date
        formatter.dateFormat = "yyyy"
        YearView.text = formatter.string(from: date!)
        formatter.dateFormat = "MMMM"
        MonthView.text = formatter.string(from: date!)
    }

    func handleCell(view: JTAppleCell!, cellState: CellState) {
        guard let Validcell = view as? CustomCalendarCell else { return }
        if cellState.isSelected {
            Validcell.DateLabel.textColor = selectedMonthColor
        }
        else {
            if cellState.dateBelongsTo == .thisMonth {
                Validcell.DateLabel.textColor = monthColor
            }
            else {
                Validcell.DateLabel.textColor = outsideMonthColor
            }
        }
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
        handleCell(view: cell, cellState: cellState)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        self.setupCalendar(from: visibleDates)
    }    
}

extension UIColor {
    convenience init(hexColor value: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x0000FF) / 255.0,
            alpha:alpha
        )
    }
}
