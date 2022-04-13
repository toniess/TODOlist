/*
 *  toniess 2022
 *
 *
 *  Panel located in left side of App and consist of menu items list
 *  can be minimized, maximized etc.
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
    id: leftPanel
    color: "transparent"
    signal newIndex(var index, var width, var x)

    Rectangle {
        id: panelSlider
        Component.onCompleted: width = col.currentWidth + 20
        height: panelListItem.height * 0.8
        radius: width
        opacity: 0.1
        y: 75
        x: col.l_margin*0.65
        property var aimY
        function startAnin(_y) {
            aimY = _y
            xAnim.start()
            widthAnim.start()
            heightAnim1.start()
        }

        NumberAnimation {
            id: noAnim
            target: panelSlider
            property: "x"
            duration: 100
            to: col.l_margin*0.65 + 5
            onStopped: noAnim2.start()
        }
        NumberAnimation {
            id: noAnim2
            target: panelSlider
            property: "x"
            duration: 100
            to: col.l_margin*0.65 - 10
            onStopped: noAnim3.start()
        }
        NumberAnimation {
            id: noAnim3
            target: panelSlider
            property: "x"
            duration: 100
            to: col.l_margin*0.65
        }

        NumberAnimation {
            id: xAnim
            target: panelSlider
            property: "y"
            duration: 150
            to: 75 + panelSlider.aimY
        }
        NumberAnimation {
            id: widthAnim
            target: panelSlider
            property: "width"
            duration: 150
            to: col.currentWidth
        }
        NumberAnimation {
            id: heightAnim1
            target: panelSlider
            property: "height"
            duration: 75
            to: 45
            onStopped: heightAnim2.start()
        }
        NumberAnimation {
            id: heightAnim2
            target: panelSlider
            property: "height"
            duration: 75
            to: panelListItem.height * 0.8
        }
    }
    Column {
        id: col
        anchors.fill: parent
        anchors.topMargin: 80
        property int currentIndex: -1
        property real currentWidth: 82
        spacing: -5
        Component.onCompleted: (panelListItem.likeTap())
        property int l_margin: (leftBorderLine.x / deadTasks.itemHeight-2)*10
        Connections{
            target: leftPanel
            function onNewIndex(_index, _width, _y) {
                if(col.currentIndex !== _index) {
                    col.currentIndex = _index
                    col.currentWidth = _width
                    panelSlider.startAnin(_y)
                } else { noAnim.start() }
            }
        }

        MyPanelListItem {
            id: panelListItem
            text: "Сегодня"
            img: "/img/today.png"
            sourcePage: "pages/todayPage.qml"
            x: parent.l_margin
            index: 0
        }
        MyPanelListItem {
            id: panelListItem2
            text: "Календарь"
            img: "/img/calendar.png"
            sourcePage: "pages/calendarPage.qml"
            x: parent.l_margin
            index: 1
        }
        Rectangle {width: parent.width; height: 20; color: "transparent"
            Rectangle{width: parent.width * 0.7; height: 1; opacity: 0.2; anchors.horizontalCenter: parent.horizontalCenter}
        }
        MyPanelListItem {
            text: "Завершенные"
            img: "/img/done.png"
            sourcePage: "pages/donePage.qml"
            x: parent.l_margin
            index: 2
        }
        MyPanelListItem {
            id: deadTasks
            text: "Просроченные"
            img: "/img/dead.png"
            sourcePage: "pages/deadPage.qml"
            x: parent.l_margin
            index: 3
        }
        Rectangle {width: parent.width; height: 20; color: "transparent"
            Rectangle{width: parent.width * 0.7; height: 1; opacity: 0.2; anchors.horizontalCenter: parent.horizontalCenter}
        }
        MyPanelListItem {
            text: "Настройки"
            img: "/img/settings.png"
            sourcePage: "pages/settingsPage.qml"
            x: parent.l_margin
            index: 4
        }
    }
}
