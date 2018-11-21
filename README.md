# Weather App

Weather app using Alamofire and SwiftyJSON 📱

Alamofire is an HTTP networking library written in Swift.
More details -> http://cocoadocs.org/docsets/Alamofire/4.5.1/

SwiftyJSON makes easy to get JSON data in Swift.
More details -> http://cocoadocs.org/docsets/SwiftyJSON/2.1.3/

## Finished App
![](https://firebasestorage.googleapis.com/v0/b/weatherapp-55f21.appspot.com/o/IMG_0571.png?alt=media&token=bda5e821-abb0-4374-be67-80bb36e4dd89)
![Finished App](https://firebasestorage.googleapis.com/v0/b/weatherapp-55f21.appspot.com/o/IMG_0572.jpeg?alt=media&token=7a9acbd2-193f-4712-a2fc-e799c51881cc)


## Fix for App Transport Security Override

```XML
	<key>NSAppTransportSecurity</key>
	<dict>
		<key>NSExceptionDomains</key>
		<dict>
			<key>openweathermap.org</key>
			<dict>
				<key>NSIncludesSubdomains</key>
				<true/>
				<key>NSTemporaryExceptionAllowsInsecureHTTPLoads</key>
				<true/>
			</dict>
		</dict>
	</dict>
```


