.. image:: https://github.com/TeleSign/ios_app_verify/blob/master/banner.jpg
    :target: https://standard.telesign.com

.. image:: https://img.shields.io/travis/TeleSign/ios_app_verify.svg
    :target: https://travis-ci.org/TeleSign/ios_app_verify

.. image:: https://img.shields.io/codecov/c/github/TeleSign/ios_app_verify.svg
    :target: https://codecov.io/gh/TeleSign/ios_app_verify

.. image:: https://img.shields.io/github/license/TeleSign/ios_app_verify.svg
    :target: https://github.com/TeleSign/ios_app_verify/blob/master/LICENSE

## Overview
The App Verify Demo app demonstrates verifying a users phone number by sending SMS to the users device, which contains a unique URL that the user can click on to complete verification automatically. The unique URL contains a URI Scheme and hostname which gets handled via deep links to the app's appropriate view controller, and the security code present in the link is sent to your server for verification. As a backup, the sample app allows for manual security code entry in the view as well.

For Android, SDK is available at https://github.com/TeleSign/android_appverify_sdk

## Requirements
	- Xcode 9.3+
	- Swift 4.1
	- iOS 11
	- Valid Telesign account:
	You will need your TeleSign customerID for authenticating the network requests

## Usage
*To run the demo app*

- Download or clone repo
- In the Networking folder, open the SessionManager.swift file
- Replace the customerId string ("XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX") with the one provided by TeleSign
- Make sure that the build scheme is set to Production
- Build and run the project

*Using the app link*
  - Add a URL types array to your info.plist file
	- Expand the array to reveal the URL identifier Key
	- Add your apps Bundle Identifier string to the URL identifier Value
	- Add a URL Schemes array beneath the URL Identifier and expand the array
	- Add your intended URL prefix string (Usually added to the Item 0 Key)

  - Open the DeepLinkManager.swift file within the Deep Linking folder
  - Make sure the 'appVerifyHost' string matches the Value you added to your URL Schemes
