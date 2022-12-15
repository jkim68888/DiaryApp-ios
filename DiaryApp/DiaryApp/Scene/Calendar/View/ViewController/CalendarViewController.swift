//
//  CalendarViewController.swift
//  DiaryApp
//
//  Created by 모상현 on 2022/10/13.
//

import UIKit

class CalendarViewController: UIViewController {
    let viewModel = CalendarViewModel()
        
    var cal = Calendar.current
    let dateFormatter = DateFormatter()
    var components = DateComponents()
    var weeks: [String] = ["일","월","화","수","목","금","토"]
    var days: [String] = []
    var daysCountInMonth = 0 //한 달에 몇일까지 있는지
    var weekdayAdding = 0 // 시작일
    
    var today_year:Int = Calendar.current.component(.year, from: Date()) // 오늘 몇년인가?
    var today_Month:Int = Calendar.current.component(.month, from: Date()) // 오늘 몇월인가?
    var today_Day:Int = Calendar.current.component(.day, from: Date()) // 오늘 몇일인가?
    
    var selectYear: Int?
    var selectMonth: Int?
    var selectDay: Int?
    
    var selectDate: Date = Date()

    @IBOutlet weak var prevMonth: UIButton!
    @IBOutlet weak var nowMonth: UILabel!
    @IBOutlet weak var nextMonth: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nowdayLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var descriptionView: UIView!
    /// 화면 불러오기
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        calendarInit()
        tableViewInit()
        initMonthBtn()
        customBackButton(self: self, target: self.navigationController!)
    }
    func tableViewInit(){
        self.tableView.dataSource = self
    }
    /// 달력 초기화
    private func calendarInit(){
        // 달력(커스텀 컬렉션뷰)에서 사용하는 delegate, dataSource를 초기화해준다.
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        // Calendar.current와 component를 사용하기 위해 초기 Date 설정해준다. 현재 Date를 불러와 현재의 년도, 월, 일을 세팅한다.
        components.year = today_year
        components.month = today_Month
        components.day = 1
        
        // 달력에서 현재 년도와 월을 설정해준다.
        nowMonth.text = "\(components.year!)년 \(components.month!)월" // "yyyy년 MM월"
        nowdayLabel.text = String(today_Day) + ". " + Date().toString_Calendar_NowDay()
        
        // calculation() 함수를 실행한다.
        calculation()
        
        
    }
    /// 달력계산
    private func calculation() {
        
        // print로 출력 시 이번 달의 한 달전의 값이 뜬다., (지금이 10월이라면 9월)
        let firstDayOfMonth = cal.date(from: components)
        
        /// 뭔지 잘 모르겠음
        let firstWeekday = cal.component(.weekday, from: firstDayOfMonth!)
        
        /// 한 달에 몇일까지 있는지 계산
        
        daysCountInMonth = cal.range(of: .day, in: .month, for: firstDayOfMonth!)!.count
        weekdayAdding = 2 - firstWeekday
        
        self.days.removeAll()
        for day in weekdayAdding...daysCountInMonth {
            if day < 1 {
                self.days.append("")
            } else {
                self.days.append(String(day))
            }
        }
    }
    /// 달력의 버튼을 초기화
    func initMonthBtn(){
        // 현재 선택된 달이 1월이라면,
        if components.month == 1{
            prevMonth.setTitle("12월", for: .normal)
            nextMonth.setTitle("\(components.month! + 1)월", for: .normal)
        // 현재 선택된 달이 12월이라면,
        }else if components.month == 12{
            prevMonth.setTitle("\(components.month! - 1)월", for: .normal)
            nextMonth.setTitle("1월", for: .normal)
        // 그외의 달이면,
        }else{
            prevMonth.setTitle("\(components.month! - 1)월", for: .normal)
            nextMonth.setTitle("\(components.month! + 1)월", for: .normal)
        }
    }

    func setUI() {
        self.title = "캘린더"
        tableView.backgroundColor = UIColor.mainBGColor
        descriptionView.backgroundColor = UIColor.mainBGColor
    }
    





    // 이전 달로 이동
    @IBAction func didPrevButtonTapped(_ sender: UIButton) {
        components.month! -= 1
        if components.month == 0{
            components.year! -= 1
            components.month = 12
        }
        print(Calendar.current.date(from: components)!.toString_Calendar())
        nowMonth.text = "\(components.year!)년 \(components.month!)월"
        self.calculation()
        self.collectionView.reloadData()
        initMonthBtn()
    }
    // 다음 달로 이동
    @IBAction func didNextButtonTapped(_ sender: UIButton) {
        components.month! += 1
        if components.month == 13{
            components.year! += 1
            components.month = 1
        }
        print(Calendar.current.date(from: components)!.toString_Calendar())
        nowMonth.text = "\(components.year!)년 \(components.month!)월"
        self.calculation()
        self.collectionView.reloadData()
        initMonthBtn()
    }
    @IBAction func addPostButtonTapped(_ sender: UIButton) {
        // 1) 현재 선택되어있는 collectionView의 Cell에있는 day값을 가져와야한다. -> 선택한 일이 몇일인가?
        // 2) PostviewerView로 넘어간다. -> 이 때, rootView를 calendarView로 해놓아야한다.
        print("✨DEBUG_addPostTapped: selectDate의 값은\(selectDate)")
        guard let postViewerVC = storyboard?.instantiateViewController(identifier: "PostViewerViewController") as? PostViewerViewController else { return }
        postViewerVC.selectDate = selectDate
        self.navigationController?.pushViewController(postViewerVC, animated: false)
        print("✨DEBUG: Calendar에서 PostViewer로 이동할 떄")
    }
}

extension CalendarViewController:UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 7
        default:
            return self.days.count
        }
    }
    /// Cell에 대한 init을 설정하는 부분
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendarCell", for: indexPath) as! CalendarCollectionViewCell
        //만약 이전, 또는 다음 버튼을 눌렀을 경우 각 cell의 값을 초기화한다.
        
        switch indexPath.section {
        case 0:
            cell.dateLabel.text = weeks[indexPath.row] // 요일
        default:
            cell.dateLabel.text = days[indexPath.row] // 일
        }
        
        if indexPath.row % 7 == 0 { // 일요일
            cell.dateLabel.textColor = .red
        } else if indexPath.row % 7 == 6 { // 토요일
            cell.dateLabel.textColor = .blue
        } else { // 평일
            cell.dateLabel.textColor = .black
        }
        // 초기화 시, 오늘 날짜를 선택하도록💄
        if getStringTodayDate() == "\(components.year!).\(components.month!).\(cell.dateLabel.text!)"{
            cell.isSelected = true
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
            
        }
        var dateStr = "\(components.year!)-\(components.month!)-\(cell.dateLabel.text!)"
        cell.tempDate = dateStr.toDate_Calendar() ?? Date()
 
        // 여기서 중요 item은 가져온 post데이터를 의미한다.
        for item in viewModel.postArray{
            // 각 셀에 부여된 날짜와 post에 기록된 날짜를 서로 비교한다.
            if cell.tempDate == item.datetime.toString().toDate_Calendar(){
                // 비교해서, 같을 경우 해당 cell의 item으로 추가한다.
                cell.postArray.append(item)
                print("DEBUG: \(indexPath.row)번째 값을 추가합니다.")
                if getStringTodayDate() == "\(components.year!).\(components.month!).\(cell.dateLabel.text!)" {
                    viewModel.tableCellPostArray = cell.postArray
                    tableView.reloadData()
                }
            }
        }
        // 선택한 날짜의 postList만 가져와야한다.
        /// 전체 postList중에서 post의 createdAt날짜가 Cell 고유의 날짜와 같은 새로만든 newPostList를 cell로 지정한다.
        
                
        return cell
    }

    func getStringTodayDate() -> String {
        let strDate = String(Calendar.current.component(.year, from: Date())) + "." +
                        String(Calendar.current.component(.month, from: Date())) + "." +
                        String(Calendar.current.component(.day, from: Date()))
        return strDate
    }
    func weekday(year: Int? = 0000, month: Int? = 00, day: Int? = 00) -> String? {
        let calendar = Calendar(identifier: .gregorian)
        
        guard let targetDate: Date = {
            let comps = DateComponents(calendar:calendar, year: year, month: month, day: day)
            return comps.date
            }() else { return nil }
        
        let day = Calendar.current.component(.weekday, from: targetDate) - 1
        
        return Calendar.current.shortWeekdaySymbols[day]
    }
    
}
extension CalendarViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CalendarCollectionViewCell
        
        // cell에서 일 가져오고
        let dateArray = cell.nowDate?.split(separator: ".").map {Int($0)}
        nowdayLabel.text = "\(cell.dateLabel.text!). \(weekday(year: dateArray?[0], month: dateArray?[1], day: dateArray?[2])!)"
        
        selectYear = components.year
        selectMonth = components.month
        if cell.dateLabel.text == ""{
            selectDay = 0
        }else{
            selectDay = Int(cell.dateLabel.text ?? "0")
        }
        
        print("DEBUG: 지금 선택한 날짜는, 년도:\(selectYear!),월:\(selectMonth!),일:\(selectDay!)")
        print("DEBUG: cell.nowDate:\(cell.nowDate) cell.tempDate\(cell.tempDate)")
        print("DEBUG: Plus 1일한 결과는? : \(cell.tempDate.toDatePlustOneDay())")
        
        selectDate = cell.tempDate.toDatePlustOneDay()
        print("✨DEBUG:\(selectDate)")
        viewModel.tableCellPostArray = cell.postArray
        tableView.reloadData()
    }
    
}
extension CalendarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let myBoundSize: CGFloat = UIScreen.main.bounds.size.width
        let cellSize : CGFloat = myBoundSize / 9
        return CGSize(width: cellSize, height: cellSize)
    }
}
extension CalendarViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tableCellPostArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarTableCell", for: indexPath) as! CalendarTableViewCell
        cell.postData = viewModel.tableCellPostArray[indexPath.row]
        return cell
    }
}
