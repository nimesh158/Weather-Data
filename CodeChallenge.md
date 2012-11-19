#Nerdery iOS Code Challenge#
For this code challenge, you will be creating a simple weather application named "Umbrella." The application will download both the current conditions and an hour by hour forecast from Weather Underground. In this code challenge we will be paying particular attention to the following items:

* **Design Fidelity:** Can you accurately and efficiently implement the design as specified in the art comps
* **Functionality:** Does the application meet the technical requirements and work reliably?* 
**Architecture:** How do you structure your application and it's classes? Would the application be extensible? How do you encapsulate data parsing and access?
* **Coding Practices and Use of Xcode:** How do you organize your files and groups? What practices do you adhere to make the code accessible and usable to other developers?
* **Fit and Finish:** Do you adhere to Apple's recommended practices?

Weather Underground's API provides free access to their service for developers. You can sign up for an API key at [http://www.wunderground.com/weather/api/](http://www.wunderground.com/weather/api/). We have included an simple API client in the attached files. 

##Settings Screen##
On the settings screen the user should be able to do the following:

* "Enter their Zip Code:" In this blank the user should be able to enter the Zip Code for the weather that they want to search.
* "Select Temperature Scale:" The user should be able to select either Fahrenheit or Centigrade for their preferred temperature scale.
* "Transition to detail screen:" After selecting valid settings, the user should be able to transition to the detail screen.

##Detail Screen##
On the detail screen the current conditions and upcoming hourly forecast should be displayed. In this screen the following considerations should be taken:

###User Interactions###
* Pressing the "Information Button" should return the user to the settings screen.

###Current Conditions###
* The reverse geo-code for the current city and state should be displayed in the header
* The weather data should be updated in accordance with the design specifications
* The current conditions should stay locked to the top of the screen.

###Hourly Forecast##
* The hourly forecast should be grouped by day of the week
* The condition name should be truncated but not allowed to shrink in size
* The icons should be from Weather Underground's Icon Set #9
* The hourly forecast should scroll beneath the current conditions header

##Application Requirements
* The application should update it's weather results each time it is activated.
* The application should gracefully handle network connection issues.
* The application should be built with the latest iOS SDK and can target the latest public release of the OS.