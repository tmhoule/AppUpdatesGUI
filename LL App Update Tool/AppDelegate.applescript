--
--  AppDelegate.applescript
--  LL App Update Tool
--
--  Created by Houle, Todd - 1170 - MITLL on 11/6/15.
--  Copyright © 2015 MIT. All rights reserved.
--

script AppDelegate
	property parent : class "NSObject"
	
	-- IBOutlets
	property theWindow : missing value
    property aTableView : missing value
    property theArrayController : missing value
    property theData : missing value
    property statusText : ""
    
	on applicationWillFinishLaunching_(aNotification)
		-- Insert code here to initialize your application before any files are opened
        refreshTime_()
    end applicationWillFinishLaunching_
	
	on applicationShouldTerminate_(sender)
		-- Insert code here to do any housekeeping before your application quits 
		return current application's NSTerminateNow
	end applicationShouldTerminate_
	
    on quitTime_(sender)
        tell me to quit
    end quitTime_
    
    on refreshTime_()   --load the list of required updates at bootup
        log "Refreshing list of updates to display"
        try
           do shell script "rm /usr/local/updateTool/updateToolTouchFiles/*"
        end try
        set listOfUpdates to {}
        set theUpdateFile to "/usr/local/updateTool/updaterInfo.txt"
        try
            set fileHandle to open for access theUpdateFile
            set Updates to paragraphs of (read fileHandle)
            repeat with nextLine in Updates
                if length of nextLine is greater than 10 then
                    set myRecord to run script nextLine
                    copy myRecord to the end of listOfUpdates
                    log "Adding " & (appName of myRecord) & " to install List"
                end if
            end repeat
        end try
        
   
        --theData is the table that shows in the GUI.  Set everything there.
        set my theData to listOfUpdates
        close access fileHandle
        set my statusText to "Ready."
    end refreshTime_


    on reloadApps_(sender)
        do shell script ("touch '/usr/local/updateTool/updateToolTouchFiles/JSS+updateapps4+rebootNo'")
        display dialog "Please reopen this application once the refresh has finished." buttons "Quit" default button 1
        tell me to quit
    end reloadApps_

    on updateApps_(sender)
        set adobeRunCount to 0
        set rebootOK to false
         repeat with oneRecord in theData
               if ((appInstallChk of oneRecord as boolean) is true) then
                       if ((reboot of oneRecord as boolean) is true) then
                             set the_button to button returned of (display dialog "A reboot is required to install these updates. " buttons {"Cancel","Reboot"} default button 2)
                             if the_button is "Cancel"
                                exit
                             else
                                set rebootOK to true
                             end if
                        end if
                end if
         end repeat

        if rebootOK is false
            set the_button to button returned of (display dialog "Applications will be closed as necessary to install. " buttons {"Cancel","Continue"} default button 2)
            if the_button is "Cancel"
                exit
            end if
        end if

        repeat with oneRecord in theData
            if ((appInstallChk of oneRecord as boolean) is true) then
                if ((reboot of oneRecord as boolean) is true) then
                     do shell script ("touch '/usr/local/updateTool/updateToolTouchFiles/" & source of oneRecord & "+" & jssPolicy of oneRecord & "+rebootYes'")
                else
                    do shell script ("touch '/usr/local/updateTool/updateToolTouchFiles/" & source of oneRecord & "+" & jssPolicy of oneRecord & "+rebootNo'")
                end if
            end if
        end repeat

        set my statusText to "Updates in Progress..."
        
        tell me to quit
    end updateApps_
    

end script
