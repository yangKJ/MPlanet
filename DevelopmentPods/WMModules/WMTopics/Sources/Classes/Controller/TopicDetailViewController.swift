//
//  TopicDetailViewController.swift
//  WMTopics
//
//  Created by Condy on 2024/5/24.
//  帖子详情页：帖子完整内容 + 评论区 + 底部评论输入框
//

import UIKit
import FeatBox
import RxSwift
import RxCocoa
import SnapKit

/// 帖子详情页
class TopicDetailViewController: BaseTableViewController<TopicDetailViewModel> {

    /// 帖子 ID
    public var topicId: Int = 0

    /// 底部评论输入框
    private lazy var commentBar: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.fy.white
        return v
    }()

    private lazy var inputTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "说点什么吧…"
        tf.font = UIFont.fy.system_14
        tf.textColor = UIColor.fy.title
        tf.borderStyle = .none
        tf.returnKeyType = .send
        // 美化：灰底浅圆角 input 框，与主色发送按钮形成主次层次
        tf.backgroundColor = UIColor.fy.gray_F7F7F7
        tf.layer.cornerRadius = 18
        tf.layer.masksToBounds = true
        // 内边距（左 14 右 14）
        let leftPad = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 1))
        tf.leftView = leftPad
        tf.leftViewMode = .always
        let rightPad = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 1))
        tf.rightView = rightPad
        tf.rightViewMode = .always
        return tf
    }()

    private lazy var sendButton: UIButton = {
        let b = BaseButton(type: .system)
        b.setTitle("发送", for: .normal)
        b.setTitleColor(UIColor.fy.white, for: .normal)
        b.titleLabel?.font = UIFont.fy.bold(14)
        // 美化：渐变背景（主色绿 → 主色绿 0.78）
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.fy.mainColor.cgColor,
            UIColor.fy.mainColor.withAlphaComponent(0.78).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        gradient.frame = CGRect(x: 0, y: 0, width: 56, height: 32)
        UIGraphicsBeginImageContextWithOptions(gradient.bounds.size, false, 0)
        gradient.render(in: UIGraphicsGetCurrentContext()!)
        let bgImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        b.setBackgroundImage(bgImage, for: .normal)
        // 美化：圆角 8 → 10
        b.layer.cornerRadius = 10
        b.layer.masksToBounds = true
        return b
    }()

    /// 顶部安全区占位高度
    private let commentBarHeight: CGFloat = 56
    private let safeBottomInset: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupInit()
        self.setupUI()
        self.setupBindings()
        self.setupViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 详情页用系统 nav bar(白色背景),恢复 .default 状态栏样式
        self.navigationController?.navigationBar.barStyle = .default
    }

    func setupInit() {
        self.title = "帖子详情"
    }

    func setupUI() {
        // 页面灰背景，对齐 Discover 风格
        self.tableView.backgroundColor = UIColor.fy.gray_F3F3F3
        // 隐藏系统分隔线
        self.tableView.separatorStyle = .none
        self.tableView.separatorInset = .zero
        self.tableView.estimatedRowHeight = 0
        self.tableView.estimatedSectionFooterHeight = 0
        self.tableView.estimatedSectionHeaderHeight = 0

        // tableView 底部留出评论输入框位置
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: commentBarHeight, right: 0)
        self.tableView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: commentBarHeight, right: 0)

        // 底部评论栏：底部贴 view 底部 safeArea，再上移 1pt 让 1px 分隔线显示
        self.view.addSubview(commentBar)
        commentBar.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.height.equalTo(commentBarHeight)
        }
        commentBar.addSubview(inputTextField)
        commentBar.addSubview(sendButton)
        inputTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.right.equalTo(sendButton.snp.left).offset(-10)
            make.height.equalTo(36)
        }
        sendButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-12)
            make.centerY.equalTo(inputTextField)
            make.width.equalTo(56)
            make.height.equalTo(32)
        }

        // 顶部分隔线
        let line = UIView()
        line.backgroundColor = UIColor.fy.line
        commentBar.addSubview(line)
        line.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }

    func setupBindings() {
        // 输入框 → VM
        inputTextField.rx.text.orEmpty
            .bind(to: viewModel.commentInputText)
            .disposed(by: rx.disposeBag)

        // 发送按钮 → 提交评论
        sendButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.sendComment()
                self?.inputTextField.resignFirstResponder()
                self?.inputTextField.text = ""
            }).disposed(by: rx.disposeBag)

        // 输入框 return → 提交
        inputTextField.rx.controlEvent(.editingDidEndOnExit)
            .subscribe(onNext: { [weak self] in
                self?.viewModel.sendComment()
                self?.inputTextField.text = ""
            }).disposed(by: rx.disposeBag)
    }

    func setupViewModel() {
        viewModel.topicId = self.topicId
        viewModel.request()
    }
}
