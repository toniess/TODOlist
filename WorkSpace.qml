/*
 *  toniess 2022
 *
 *
 *  This is space located in right side of app and shows calendar/note(tasks)/settings
 *  when same panel point is active
 *
*/

import QtQuick.LocalStorage 2.0
import QtQuick.Controls 2.5
import QtQuick.Window 2.3
import QtQuick 2.15
import QtQml 2.3
import "Database.js" as Db
import "Time.js" as Time

Rectangle {
    id: workSpace
    color: "#222329"
    radius: width/100
    anchors{
        fill: parent
        margins: 1
        leftMargin: leftBorderLine.x+5
    }
    clip: true
    property string pageTitle
    property string currentCompomemt
    property int todayDoneCount: 0
    property int progressToday
    signal setCurrentPage(var text, var page)


    Connections {
        function onSetCurrentPage(text, page) {

            if(page === "pages/calendarPage.qml" || page === "pages/settingsPage.qml")
                loader.source = page
            else
                loader.source = "pages/todayPage.qml"
            var k
            switch (text) {
                case "Сегодня": k = "today"; break;
                case "Календарь": k = "calendar"; break;
                case "Завершенные": k = "done"; break;
                case "Просроченные": k = "dead"; break;
                default: k = "today"; break;
            }
            if(k !== "calendar"){
                pageTitle = text
                mainWindow.update(k)
            }
        }
    }
    Text {
        id: headerText
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 15
        anchors.leftMargin: 20
        font{
            family: mainFont.name
            pointSize: 30
        }
        text: pageTitle
        color: "white"
    }
    Rectangle {
        id: titleLine
        anchors.top: parent.top
        width: parent.width * 0.7
        opacity: 0.2
        height: 1
        anchors.topMargin: 15+headerText.height + 10

    }
    Loader{
        id: loader
        anchors.fill: parent
        anchors.bottomMargin: 25
        anchors.topMargin: titleLine.y
        source: "qrc:/pages/todayPage.qml"
    }
    Rectangle {
        id: rectdown
        anchors.top: loader.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        opacity: 0.05
    }
    Row {
        id: row
        anchors.fill: rectdown
        anchors.leftMargin: 10
        spacing: 10
        Text {
            id: progress
            text: "Завершено: " + progressToday + "%"
            color: "white"
            anchors.verticalCenter: parent.verticalCenter
        }
        Rectangle {
            width: 1
            height: parent.height * 0.6
            anchors.verticalCenter: parent.verticalCenter
            opacity: 0.2
        }
        Text {
            id: timeNprogress
            Timer{
                interval: 3000
                running: true
                repeat: true
                triggeredOnStart: true
                onTriggered: {
                    var currentTime = new Date()
                    let a = 23-currentTime.getHours()
                    var k = "До конца дня: " + a
                    if(a%10 == 1) k += " час"
                    else if(a%10 > 1 && a%10 < 5) k += " часа"
                    else {k += " часов"}

                    a = 60-currentTime.getMinutes()
                    k+= " " + a
                    if(a > 4 && a < 21) k += " минут"
                    else if(a%10 == 1) k += " минута"
                    else if(a%10 > 1 && a%10 < 5) k += " минуты"
                    else {k += " минут"}

                    timeNprogress.text = k
                }
            }
            color: "white"
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
