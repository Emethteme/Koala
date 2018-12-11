//
//  ViewController.swift
//  Koala
//
//  Created by Emeth on 2017/12/13.
//

import UIKit
import Sipp3XII

class ViewController: UIViewController, Sipp3XIIDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var wakeupView: UIView!
    @IBOutlet weak var koalaNameTextField: UITextField!
    @IBOutlet weak var stillSleepLabel: UILabel!
    @IBOutlet weak var wakeupButton: UIButton!
    @IBOutlet weak var progressCircle: UIImageView!

    @IBOutlet weak var koalaHeadView: UIView!
    @IBOutlet weak var zzz1: UIImageView!
    @IBOutlet weak var zzz2: UIImageView!
    @IBOutlet weak var zzz3: UIImageView!
    
    @IBOutlet weak var koalaHead: UIImageView!
    
    @IBOutlet weak var sportInfoView: UIView!
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var calorieLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var koalaStarView: UIView!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    
    @IBOutlet weak var koalaStarHead: UIImageView!
    
    @IBOutlet weak var sportingView: UIView!
    @IBOutlet weak var stepCounterLabel: UILabel!
    @IBOutlet weak var sportStatusLabel: UILabel!
    
    @IBOutlet weak var takeBreakView: UIView!
    
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    
/**************************************************/
//                     各種變數
/**************************************************/
    // 儲存裝置名稱的變數
    var userDefaults: UserDefaults!
    // 裝置名稱
    var deviceName: String!
    
    // 藍牙連線
    var sipp3XII: Sipp3XIIModule!
    // 是否已連線
    var isConnected: Bool!
    
    // 圈圈計數器
    var circleCounter: Int! = 0
    
    // 是否有儲存裝置名稱
    var isSaved: Bool!
    
    // 是否在運動中
    var isSporting: Bool! = false
    // 運動中步數計數器
    var stepCounter: Int! = 0
    
    // 儲存接收資訊(步數、卡洛里、距離、時間)
    var step: Int!
    var calorie: Int!
    var distance: Int!
    var duration: Int!
    
    // 在開始運動時，儲存初始資訊
    var initStep: Int!
    var initCalorie: Int!
    var initDistance: Int!
    var initDuration: Int!

    func sipp3XII(step: Int, calorie: Int, distance: Int, duration: Int) {
        // 接收資訊(步數、卡洛里、距離、時間)
        self.step = step
        self.calorie = calorie
        self.distance = distance
        self.duration = duration
        
        // 顯示今日運動資訊
        stepLabel.text = "步行\(self.step!)步"
        calorieLabel.text = "消耗\(self.calorie!)大卡"
        distanceLabel.text = "步行\(self.distance!)公尺"
        durationLabel.text = "步行\(self.duration!)分鐘"
        
        // 判斷是否在運動中
        if isSporting {
            // 計算走了幾步
            stepCounter = self.step - self.initStep
            // 顯示步數
            stepCounterLabel.text = "\(stepCounter!)步"
            
            // 根據步數顯示貼心鼓勵
            if stepCounter >= 10 && stepCounter <= 49 {
                sportStatusLabel.text = "弱弱的⋯⋯"
                koalaStarHead.image = #imageLiteral(resourceName: "koala_despise")
            }
            else if stepCounter >= 50 && stepCounter <= 99 {
                sportStatusLabel.text = "太棒了！"
                koalaStarHead.image = #imageLiteral(resourceName: "koala_wakeup")
                
                // 星星動畫
                if self.star1.image != #imageLiteral(resourceName: "star_white") {
                    self.star1.image = #imageLiteral(resourceName: "star_white")
                    UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear],  animations: {
                        self.star1.transform = CGAffineTransform.init(scaleX: 2, y: 2)
                    }, completion: { finish in
                        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear],  animations: {
                            self.star1.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                        }, completion: nil)
                    })
                }
            }
            else if stepCounter >= 100 && stepCounter <= 299 {
                sportStatusLabel.text = "太強大了！"
                koalaStarHead.image = #imageLiteral(resourceName: "koala_surprise")
                
                // 星星動畫
                if self.star2.image != #imageLiteral(resourceName: "star_white") {
                    self.star2.image = #imageLiteral(resourceName: "star_white")
                    UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear],  animations: {
                        self.star2.transform = CGAffineTransform.init(scaleX: 2, y: 2)
                    }, completion: { finish in
                        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear],  animations: {
                            self.star2.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                        }, completion: nil)
                    })
                }
            }
            else if stepCounter >= 300 {
                sportStatusLabel.text = "好厲害！！"
                koalaStarHead.image = #imageLiteral(resourceName: "koala_admire")
                
                // 星星動畫
                if self.star3.image != #imageLiteral(resourceName: "star_white") {
                    self.star3.image = #imageLiteral(resourceName: "star_white")
                    UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear],  animations: {
                        self.star3.transform = CGAffineTransform.init(scaleX: 2, y: 2)
                    }, completion: { finish in
                        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear],  animations: {
                            self.star3.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                        }, completion: nil)
                    })
                }
            }
            
            // 震動頭像
            UIView.animate(withDuration: 0.3, delay: 0, options: [],  animations: {
                self.koalaStarHead.center = CGPoint(x: self.koalaStarHead.center.x, y: self.koalaStarHead.center.y + 10)
            }, completion: { finish in
                UIView.animate(withDuration: 0.3, delay: 0, options: [],  animations: {
                    self.koalaStarHead.center = CGPoint(x: self.koalaStarHead.center.x, y: self.koalaStarHead.center.y - 10)
                }, completion: nil)
            })
        }
    }
    
    func sipp3XII(state: BleState) {
        // 判斷是否已連線
        if state == BleState.serviceSearchCompleted {
            isConnected = true
        } else {
            isConnected = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sipp3XII = Sipp3XIIModule(delegate: self)
        
        // 手勢用
        self.view.addGestureRecognizer(tapGesture)
        
        // 輸入裝置名稱時捲動畫面
        koalaNameTextField.delegate = self
        
        // 取得儲存的裝置名稱
        userDefaults = UserDefaults.standard
        if let name = userDefaults.object(forKey: "deviceName") as? String {
            // 取出成功，顯示「還在睡」
            stillSleepLabel.alpha = 1
            
            deviceName = name
            isSaved = true
        } else {
            // 取出失敗，顯示輸入框
            koalaNameTextField.isEnabled = true
            koalaNameTextField.alpha = 1
            
            isSaved = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // zzz動畫
        zzzAnimation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
/**************************************************/
//                     各種按鈕
/**************************************************/
    // 按下「叫醒他」按鈕
    @IBAction func wakeupButtonClick(_ sender: Any) {
        // 隱藏「輸入框」、「還在睡」、「按鈕」
        koalaNameTextField.isEnabled = false
        koalaNameTextField.alpha = 0
        stillSleepLabel.alpha = 0
        wakeupButton.isEnabled = false
        wakeupButton.alpha = 0
        
        // 判斷是否用輸入框的內容作為裝置名稱
        if !isSaved {
            deviceName = koalaNameTextField.text!
        }
        // 第一次連線
        sipp3XII.connectToDevice(name: deviceName)
        
        // 顯示圈圈
        progressCircle.alpha = 1
        // 圈圈動畫
        progressCircleAnimation()
    }
    
    // 按下「去運動」按鈕
    @IBAction func gosportButtonClick(_ sender: Any) {
        // 隱藏「原本的koala頭像」、「運動資訊」
        self.koalaHeadView.isUserInteractionEnabled = false
        self.koalaHeadView.alpha = 0
        self.sportInfoView.isUserInteractionEnabled = false
        self.sportInfoView.alpha = 0
        
        // 顯示「星星的koala頭像」、「運動中資訊」
        self.koalaStarView.isUserInteractionEnabled = true
        self.koalaStarView.alpha = 1
        self.sportingView.isUserInteractionEnabled = true
        self.sportingView.alpha = 1
        
        // 開始計數「運動中步數」
        self.isSporting = true
        // 「運動中步數」歸零
        self.stepCounter = 0
        
        // 初始化運動狀態
        stepCounterLabel.text = "0步"
        sportStatusLabel.text = "1! 2! 1! 2!"
        self.koalaStarHead.image = #imageLiteral(resourceName: "koala_wakeup")
        
        // 取得當前運動資訊
        self.initStep = self.step
        self.initCalorie = self.calorie
        self.initDistance = self.distance
        self.initDuration = self.duration
    }
    
    // 按下「我還要動一動」按鈕
    @IBAction func stillSportButtonClick(_ sender: Any) {
        // 顯藏
        takeBreakView.isUserInteractionEnabled = false
        takeBreakView.alpha = 0
    }
    
    // 按下「休息一下」按鈕
    @IBAction func takeBreakButtonClick(_ sender: Any) {
        isSporting = false
        
        takeBreakView.isUserInteractionEnabled = false
        takeBreakView.alpha = 0
        
        // 顯示「原本的koala頭像」、「運動資訊」
        self.koalaHeadView.isUserInteractionEnabled = true
        self.koalaHeadView.alpha = 1
        self.sportInfoView.isUserInteractionEnabled = true
        self.sportInfoView.alpha = 1
        
        // 隱藏「星星的koala頭像」、「運動中資訊」
        self.koalaStarView.isUserInteractionEnabled = false
        self.koalaStarView.alpha = 0
        self.sportingView.isUserInteractionEnabled = false
        self.sportingView.alpha = 0
    }
    
    // 單點手勢
    @IBAction func tapGestureHandler(_ sender: Any) {
        if isSporting && takeBreakView.alpha == 0 {
            takeBreakView.isUserInteractionEnabled = true
            takeBreakView.alpha = 1
        }
    }
    
/**************************************************/
//                     各種動畫
/**************************************************/
    // ZZZ動畫
    func zzzAnimation() {
        UIView.animate(withDuration: 3, delay: 0, options: [.repeat],  animations: {
            self.zzz1.center = CGPoint(x: self.zzz1.center.x + 50, y: self.zzz1.center.y - 50)
            self.zzz1.alpha = 0
        }, completion: nil)
        
        UIView.animate(withDuration: 6, delay: 0.3, options: [.repeat],  animations: {
            self.zzz2.center = CGPoint(x: self.zzz2.center.x + 50, y: self.zzz2.center.y - 75)
            self.zzz2.alpha = 0
        }, completion: nil)
        
        UIView.animate(withDuration: 9, delay: 0.7, options: [.repeat],  animations: {
            self.zzz3.center = CGPoint(x: self.zzz3.center.x + 50, y: self.zzz3.center.y - 25)
            self.zzz3.alpha = 0
        }, completion: nil)
    }
    
    // 轉圈圈動畫
    func progressCircleAnimation() {
        // 開始轉圈圈，每2秒轉一圈
        UIView.animate(withDuration: 1, delay: 0, options: [.curveLinear], animations: {
            self.progressCircle.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi)
        }, completion:  { finish in
            UIView.animate(withDuration: 1, delay: 0, options: [.curveLinear], animations: {
                self.progressCircle.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi*2)
            }, completion: { finish in
                // 轉完一圈後判斷是否已連線成功
                if self.isConnected {
                    // 連線成功，隱藏圈圈，圈圈計數器歸零
                    self.circleCounter = 0
                    
                    self.progressCircle.alpha = 0
                    
                    // 移除zzz動畫
                    self.zzz1.layer.removeAllAnimations()
                    self.zzz2.layer.removeAllAnimations()
                    self.zzz3.layer.removeAllAnimations()
                    //self.view.layer.removeAllAnimations()
                    
                    // 呼叫連線成功動畫
                    self.connectSuccessAnimation()
                } else {
                    // 連線失敗，圈圈計數器加一
                    self.circleCounter  = self.circleCounter + 1
                    
                    // 判斷是否已30秒
                    if self.circleCounter == 15 {
                        // 已30秒，停止轉圈圈，恢復按鈕與其他物件，圈圈計數器歸零
                        self.circleCounter = 0
                        self.progressCircle.alpha = 0
                        self.wakeupButton.isEnabled = true
                        self.wakeupButton.alpha = 1
                        
                        // 根據是否有儲存裝置名稱恢復不同物件
                        if self.isSaved {
                            self.stillSleepLabel.alpha = 1
                        } else {
                            self.koalaNameTextField.isEnabled = true
                            self.koalaNameTextField.alpha = 1
                        }
                    } else {
                        // 還沒30秒，再一次嚐試連線，呼叫轉圈圈動畫，繼續轉圈圈
                        if self.circleCounter % 5 == 0 {
                            self.sipp3XII.connectToDevice(name: self.deviceName)
                        }
                        self.progressCircleAnimation()
                    }
                }
            })
        })
    }
    
    // 連線成功動畫
    func connectSuccessAnimation() {
        UIView.animate(withDuration: 2, delay: 0, options: [.curveLinear],  animations: {
            self.koalaHead.center = CGPoint(x: self.koalaHead.center.x, y: self.koalaHead.center.y-50)
            self.koalaHead.transform = CGAffineTransform.init(scaleX: 0.8, y: 0.8)
        }, completion: { finish in
            self.koalaHead.image = #imageLiteral(resourceName: "koala_wakeup")
            
            self.wakeupView.isUserInteractionEnabled = false
            self.wakeupView.alpha = 0
            self.sportInfoView.isUserInteractionEnabled = true
            self.sportInfoView.alpha = 1

            self.stepCounterLabel.text = "0步"
        })
    }
}

// 輸入裝置名稱時捲動畫面
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 250), animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
}
