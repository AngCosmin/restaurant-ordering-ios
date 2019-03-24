import UIKit
import Firebase
import GoogleSignIn
import SVProgressHUD

class LoginViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate  {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: false);
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        SVProgressHUD.show()
        
        if error != nil {
            print (error)
            SVProgressHUD.showError(withStatus: (error as! String))
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        // Authenticate
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if error != nil {
                print (error!)
                return
            }
            
            print (authResult!.user.email! + " " + authResult!.user.displayName!)
            SVProgressHUD.dismiss()
            self.performSegue(withIdentifier: "goToMainScreen", sender: self)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    @IBAction func onLoginWithGoogleClicked(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
}

