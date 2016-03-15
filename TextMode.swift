//
//  TextMode.swift
//  prototype
//
//  Created by Yan Sun on 4 Mar 16.
//  Copyright © 2016 Yan Sun. All rights reserved.
//

#if os(iOS)
import UIKit
#elseif os(watchOS)
import WatchKit
#endif

let IS_DEV : Bool = false
let TRIAL_TIME : Int = 10
let MESSAGE_TRIAL_TEXT = "text"
let MESSAGE_TRIAL_DURATION = "duration"
let MESSAGE_TRIAL_MODE = "mode"
let MESSAGE_TRIAL_NUM = "num"
let MESSAGE_TRIAL_TEST_RUN = "istestrun"
let MESSAGE_TRIAL_STATE = "message"
let MESSAGE_TRIAL_STATE_STARTED = "started"
let MESSAGE_TRIAL_STATE_FINISHED = "finished"
let MESSAGE_TRIAL_STATE_CANCEL = "cancel"
let TRIALS_PER_GROUP = 20
let TRIAL_GROUP_TEXTS : [ Int : [ String ] ] =
    [ 0 : [ "California lawmakers voted to raise the smoking age from 18 to 21, it is the second state to restrict teenagers from buying tobacco products.",
            "A 93-year-old Ohio woman has received the high school diploma she was denied because of rules that expelled married students.",
            "The UK Government has stated that children in Britain will no longer be required to take compulsory, externally marked tests at the age of fourteen.",
            "Registering 5,081,441 views in the past week alone, an international advertisement featuring roller-skating babies has become a YouTube sensation.",
            "Thousands of rebels in Nigeria's volatile Niger Delta have surrendered their weapons, after they accepted a government offer of amnesty, reports say.",
            "A baby pink elephant was sighted in the African country of Botswana on Friday by a filmmaker for the BBC as he was filming for a wildlife documentary.",
            "Five Thai fishing boat captains were sentenced to three years in jail for human trafficking in connection with slavery in the seafood industry.",
            "An Atlanta small insurance company require employees to carry firearms at the office has sparked a debate on gun safety in the workplace.",
            "A would-be robber in Pennsylvania had some pretty poor timing when he pulled a gun on his taxi driver with a sheriff's deputy behind him.",
            "A national organization says it is worried about a bill that would allow classes about the bible to be taught in Kentucky public schools.",
            "An examination of the skeleton of an elephant who died suddenly at an Oklahoma City zoo showed 'severe tooth abnormalities'.",
            "Parks and Wildlife Department officials say they have acquired equipment designed to block the smuggling of nuclear material from Texas coastlines.",
            "A woman who stole a donation jar from a convenience store is questioned by police after a Facebook video recorded the theft.",
            "Denver's unadjusted unemployment rate fell to 3.0% in January, from December's rate of 3.1%, and well below the 4.6% of a year ago.",
            "Rescue crews pulled a person out of the Sacramento River after the individual fell in the water Monday night, officials said.",
            "A proposed community empowerment center in Ferguson will be three times larger than originally planned, thanks to new donations and tax credits.",
            "Construction crews are racing against the clock to restore a long stretch of beach on Siesta Key before sea turtle nesting season." ],
      1 : [ "A World Health Organization (WHO) committee comprising of 43 African health ministers has declared a tuberculosis emergency on the continent.",
            "Imperial Tobacco, a United Kingdom-based tobacco company, has announced that it will cut 2,440 jobs as part of a restructuring plan.",
            "Police in Salinas, California have identified a 15-year-old boy killed on August 6 in what is believed to be a gang related shooting.",
            "A drug trial in Sydney, Australia was aborted yesterday after several jurors were found to be playing sudoku puzzles during proceedings.",
            "A press room across the street of the White House was evacuated after a bomb sniffing dog had a reaction to a van it was searching.",
            "After testing positive for salmonella, a California produce company has recalled fresh bagged spinach from the United States and Canada.",
            "Police officials have said that a suicide car bomber has killed seven people and injured a further fifteen at a western Iraq security checkpoint.",
            "Out of the 8670 noise complaints Washington's Reagan National Airport received last year, officials say a whopping 6500 of them came from the same person.",
            "A Virginia jail is no longer allowing inmates to receive photographs after officials found inmates chewing on pictures that had been soaked in a drug.",
            "Louisiana residents are taking stock of damages after a massive rain submerged roads, washed out bridges, and forced residents to flee homes.",
            "The Whitley County Detention Center is looking for two escaped inmates they say walked away from work detail Monday afternoon.",
            "Thousands of Western Washington residents were still without power Monday after a second windstorm in less than a week swept through the region.",
            "Texas State Fair officials announced the annual 24-day state fair will be based on the theme of 'Celebrating Texas Agriculture'.",
            "Firefighters treated two cats for smoke inhalation after they were found in a burning basement late Friday.",
            "A Denver company is opening a marijuana-themed resort in Colorado, but not planning to sell any pot 'for legal purposes.'",
            "Two San Jose State University students were sentenced to 30 days of weekend work for forcing a bicycle lock around the neck of their black roommate.",
            "Tuition will remain flat at the University of Maine System this fall, after a vote by the system board of trustees." ],
      2 : [ "Many women say video games such as ‘World of Warcraft’ are rife with harassment, stalking and sexism that game companies don't police effectively.",
            "An Orange County defense attorney suffered a bloodied face and fractured nose after a brawl with a district attorney's investigator in a courthouse.",
            "Somali pirates released a Greek-owned cargo ship and its 24 Ukrainian crew members earlier today, after seven months in captivity.",
            "Local officials in southern Afghanistan say a roadside bomb blasted a passenger bus Tuesday, killing 30 civilians and wounding at least 39 others.",
            "Police detained a nine-year-old after a blaze started in a wholesale market in Huizhou, Guangdong, southern China on Thursday afternoon.",
            "A rocket launcher and at least one rocket have been found near the Parliament building in the Pakistani capital Islamabad, the police have said.",
            "Western Canadian Justice ministers met Saturday to press for changes to the criminal code in regards to organised crime and crime violence.",
            "Police are investigating a shooting on Buffalo's east side late Saturday night which left one person in critical condition at a local hospital.",
            "Following a number of hunger strikes to protest prison conditions, a prisoner at the United States prison camp killed himself on Wednesday.",
            "An animal rights protestor who left home-made petrol bombs at buildings of the University of Oxford has been jailed for ten years.",
            "Police investigators think some road sign thefts in Madison County could be connected to the assault of a county highway worker.",
            "Washington lawmakers whom adjourned their session without passing a budget bill was immediately called back for a special session by the Governor.",
            "The annual storytelling festival in Denton will have professional and amateur storytellers taking the stage to their tale.",
            "State lawmakers in Utah passed a bill setting guidelines for police body-worn cameras, pending the governor’s approval.",
            "A report issued by the Denver city’s police watchdog shows a few officers have been caught using criminal databases for personal reasons.",
            "Top Missouri lawmakers are claiming exemption from having to release their emails and daily calendars under the State’s Sunshine Law.",
            "The Madison Paper Industries mill will close this May, leaving 214 people without jobs, according the mill’s Finnish parent company." ]
    ]
let TRIAL_GROUP_MODES : [ Int : [ TextMode ] ] =
    [ 0 : [ .RSVP, .Scroll, .Ticker, .RSVP, .Scroll, .Ticker, .RSVP, .Scroll, .Ticker,
            .RSVP, .Scroll, .Ticker, .RSVP, .Scroll, .Ticker, .RSVP, .Scroll, .Ticker,
            .RSVP, .Scroll, .Ticker, .RSVP, .Scroll, .Ticker, .RSVP, .Scroll, .Ticker,
            .RSVP, .Scroll, .Ticker, .RSVP, .Scroll, .Ticker, .RSVP, .Scroll, .Ticker,
            .RSVP, .Scroll, .Ticker, .RSVP, .Scroll, .Ticker, .RSVP, .Scroll, .Ticker,
            .RSVP, .Scroll, .Ticker, .RSVP, .Scroll, .Ticker, .RSVP, .Scroll, .Ticker,
            .RSVP, .Scroll, .Ticker, .RSVP, .Scroll, .Ticker],
      1 : [ .Scroll, .Ticker, .RSVP, .Scroll, .Ticker, .RSVP, .Scroll, .Ticker, .RSVP,
            .Scroll, .Ticker, .RSVP, .Scroll, .Ticker, .RSVP, .Scroll, .Ticker, .RSVP,
            .Scroll, .Ticker, .RSVP, .Scroll, .Ticker, .RSVP, .Scroll, .Ticker, .RSVP,
            .Scroll, .Ticker, .RSVP, .Scroll, .Ticker, .RSVP, .Scroll, .Ticker, .RSVP,
            .Scroll, .Ticker, .RSVP, .Scroll, .Ticker, .RSVP, .Scroll, .Ticker, .RSVP,
            .Scroll, .Ticker, .RSVP, .Scroll, .Ticker, .RSVP, .Scroll, .Ticker, .RSVP,
            .Scroll, .Ticker, .RSVP, .Scroll, .Ticker, .RSVP],
      2 : [ .Ticker, .RSVP, .Scroll, .Ticker, .RSVP, .Scroll, .Ticker, .RSVP, .Scroll,
            .Ticker, .RSVP, .Scroll, .Ticker, .RSVP, .Scroll, .Ticker, .RSVP, .Scroll,
            .Ticker, .RSVP, .Scroll, .Ticker, .RSVP, .Scroll, .Ticker, .RSVP, .Scroll,
            .Ticker, .RSVP, .Scroll, .Ticker, .RSVP, .Scroll, .Ticker, .RSVP, .Scroll,
            .Ticker, .RSVP, .Scroll, .Ticker, .RSVP, .Scroll, .Ticker, .RSVP, .Scroll,
            .Ticker, .RSVP, .Scroll, .Ticker, .RSVP, .Scroll, .Ticker, .RSVP, .Scroll,
            .Ticker, .RSVP, .Scroll, .Ticker, .RSVP, .Scroll]
    ]
let TEST_RUN_TEXT = "A 12-year-old girl has died after the car they were travelling in slipped on ice and rolled off the side of the road near Darfield, Canterbury."

enum TextMode {
    case Scroll
    case Ticker
    case RSVP
    
    var description : String {
        switch self {
            case .Scroll: return "Scroll"
            case .Ticker: return "Ticker"
            case .RSVP: return "RSVP"
        }
    }
    
    var controllerName : String {
        switch self {
            case .Scroll: return "scroll-controller"
            case .Ticker, .RSVP: return "canvas-controller"
        }
    }
    
    var fontSize : CGFloat {
        return 20.0
    }
    
    var lineHeight : CGFloat {
        switch self {
            case .Scroll : return self.fontSize + 1.0
            case .Ticker, .RSVP : return self.fontSize
        }
    }
    
    var attributes : [ String : AnyObject ] {
        let paragraphAttrs = NSMutableParagraphStyle.init()
        paragraphAttrs.setParagraphStyle( NSParagraphStyle.defaultParagraphStyle() )
        paragraphAttrs.lineSpacing = self.lineHeight - self.fontSize
        paragraphAttrs.maximumLineHeight = self.lineHeight
        
        return [
            NSFontAttributeName : UIFont.systemFontOfSize( self.fontSize ),
            NSParagraphStyleAttributeName : paragraphAttrs,
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSBackgroundColorAttributeName : UIColor.blackColor()
        ]
    }
}


func TextModeToString( mode : TextMode ) -> String {
    return mode.description
}


func StringToTextMode( descript : String ) -> TextMode {
    switch descript {
        case TextMode.Ticker.description : return TextMode.Ticker
        case TextMode.RSVP.description : return TextMode.RSVP
        default : return TextMode.Scroll
    }
}