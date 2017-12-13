//
//  Suggestions.swift
//  Urja
//
//  Created by Ishita Chordia on 3/27/16.
//  Copyright © 2016 Ishita Chordia. All rights reserved.
//

import Foundation

class Suggestions {
    
    
    //can do every day. Little things. putting positivity into the universe.Not directed at one person. "Put some positive energy into the universe."
    //Put some good vibes out there for them.
        
    struct Section {
        var name: String!
        var items: [String]!
        var collapsed: Bool!
        
        init(name: String, items: [String]) {
            self.name = name
            self.items = items
            self.collapsed = true
        }
    }
    
    var sectionsData = [
        
         Section(name: "enter your own kind deed", items:  ["e.g., \"helped someone cross the road\""]),
         
        Section(name: "at a party", items: [
            "Give someone a ridiculously good hug",
            "Genuinely smile and compliment a stranger",
            "After the party, donate the flowers to a nursing home"]),
        
        Section(name: "at home", items:  [
            "Give away gently used, yet glamorous clothing",
            "Find a copy of your favorite book to donate to a school or library",
            "Make Nutella sandwiches for the local food bank",
            "Send a care package to a soldier (Operation Gratitude)",
            "Send a letter to a hospitalized child (Cards For Hospitalized Kids)"]),
        
        Section(name: "at school/work", items: [
            "Assume the absolute best about those you meet today",
            "Say good morning to the person next to you in the elevator",
            "Leave a Hershey's kiss & sweet note for someone to find"]),
        
        Section(name: "commuting", items:  [
            "Instead of road rage, practice road kindness",
            "Use public transportation today",
            "Give up your seat for someone on the bus or subway",
            "Put a coin in an expired meter",
            "Let the person who seems rushed cut in front of you",
            "Carpool"]),
        
        Section(name: "eating out", items:  [
            "Send dessert to another table",
            "Leave a friendly note along with your tip",
            "Leave an inspirational book for the next patron"]),
        
        Section(name: "going about your day", items:  [
            "Turn off all the lights that are not in use",
            "Be vegetarian or vegan for a day",
            "Recycle all the paper, plastic, and glass you use",
            "Carry healthy granola bars with you and give them to the hungry"]),
        
        Section(name: "online", items:  ["Register as an organ donor",
            "Use the search engine Ecosia- they use their profits to plant trees",
            "Join the bone marrow registry to help patients with blood cancer",
            "Help the UN feed the hungry- play games on FreeRice.com"]),

        Section(name: "outside", items:  ["Plant something beautiful",
            "Pick up trash along a littered path",
            "Host a clean-up party at a public park or beach",
            "Leave candy in a sad mailbox",
            "Write or draw a positive message with sidewalk chalk"]),
        
    ]
    
    
    var sectionsDataPastTense = [
        
        Section(name: "Enter your own kind deed", items:  ["e.g., \"helped someone cross the road\""]),

        Section(name: "At A Party", items: [
            "gave someone a ridiculously good hug",
            "genuinely smiled and complimented a stranger",
            "donated flowers to a nursing home"]),
        
        Section(name: "At Home", items:  ["gave away gently used clothing",
            "donated a copy of a favorite book to a school or library",
            "made Nutella sandwiches for the local food bank",
            "sent a care package to a soldier",
            "sent a letter to a hospitalized child"]),
        
        Section(name: "At School/Work", items: [
            "assumed the best about others",
            "said good morning to others in the elevator",
            "left a Hershey's kiss and a note for someone to stumble upon"]),
        
        Section(name: "Commuting", items:  [
            "practiced road kindness, instead of road rage",
            "helped our planet by using public transportation",
            "gave up a seat for someone on the bus or subway",
            "put a coin in an expired meter",
            "let a rushed person cut in line",
            "helped our planet by carpooling"]),
        
        Section(name: "Eating Out", items:  [
            "sent dessert to another table",
            "left a friendly note along with a tip",
            "left an inspirational book at a restaurant/cafe"]),
        
        Section(name: "Going About Your Day", items:  [
            "helped our planet by remembering to turn off the lights",
            "was vegetarian or vegan",
            "helped our planet by recycling paper, plastic, and glass",
            "gave away granola bars to the hungry"]),
        
        Section(name: "Online", items:  [
            "registered as an organ donor",
            "used Ecosia- a website whose profits are used to plant trees",
            "joined the bone marrow registry to help patients with cancer",
            "helped feed the hungry by spending time on FreeRice.com"]),
        
        Section(name: "Outside", items:  [
            "planted something beautiful",
            "picked up trash along a littered path",
            "hosted a clean-up party at a public park or beach",
            "left candy in a sad mailbox",
            "wrote a positive message with sidewalk chalk"])
    ]
    
}
