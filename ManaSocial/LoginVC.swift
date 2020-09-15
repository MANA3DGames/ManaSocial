import UIKit

class LoginVC: MyBaseViewController
{
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    let model = LoginModel()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        createProgressBG()
        
        // Prevent autofill
        passwordTxt.textContentType = .oneTimeCode
        
        justForQuickTesting()
    }

    func justForQuickTesting()
    {
        let hostName = ProcessInfo.processInfo.hostName
        if hostName == "mahmouds-mini"
        {
            let btn = UIButton( frame: CGRect( x: 10, y: 10, width: 100, height: 100 ) )
            btn.setTitle( "Quick Login", for: UIControl.State.normal )
            btn.addTarget( self, action: #selector( quickLoginInfo ), for: UIControl.Event.touchDown )
            self.view.addSubview( btn )
        }
    }
    
    @objc func quickLoginInfo()
    {
        emailTxt.text = "kingodesu@gmail.com"
        passwordTxt.text = "123456"
        onLoginBtnClicked( self )
    }
    
    
    @IBAction func onLoginBtnClicked(_ sender: Any)
    {
        // Check if email textfield is empty?
        if checkIsEmpty( textField: emailTxt )
        {
            return
        }
        
        // Check if password textfield is empty?
        if checkIsEmpty( textField: passwordTxt )
        {
            return
        }
        
        // Hide keyboard.
        self.view.endEditing( true )
        
        // Send login request.
        model.login( email: emailTxt.text!.lowercased(), password: passwordTxt.text!, sender: self )
    }
    
    @IBAction func onForgetPasswordBtnClicked(_ sender: Any)
    {
        moveToViewController( from: self, toID: VCIDInfo.ID_RESET_PASSWORD_VC )
    }
    
    @IBAction func onRegisterBtnClicked(_ sender: Any)
    {
        moveToViewController( from: self, toID: VCIDInfo.ID_REGISTER_VC )
    }
}
