/*
 *  toniess 2022
 *
 *
 *  Appframe imitate system window menu and system buttons like close/hide app
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
    color: "transparent"
    property bool isWindowActive: mainWindow.active
    Row {
        HoverHandler {id: hh; cursorShape: Qt.ArrowCursor}
        anchors {
            top: parent.top
            left: parent.left
            leftMargin: 20
            topMargin: 20
        }

        spacing: 8
        SystemMenuButton {
            color: isWindowActive? "#ed6a5e" : "#606062"
            Rectangle {
                rotation: 45
                visible: hh.hovered
                height: 2
                width: 8
                radius: 2
                color: "#8c1a11"
                anchors.centerIn: parent
            }
            Rectangle {
                rotation: -45
                visible: hh.hovered
                height: 2
                width: 8
                radius: 2
                color: "#8c1a11"
                anchors.centerIn: parent
            }
            function _tapped() {Qt.quit()}
        }
        SystemMenuButton {
            color: isWindowActive? "#f4bf4f" : "#606062"
            Rectangle {
                visible: hh.hovered
                height: 2
                width: 8
                radius: 2
                color: "#8c1a11"
                anchors.centerIn: parent
            }
            function _tapped() {mainWindow.showMinimized()}
        }
        SystemMenuButton {
//            color: "#61c554"
            color: "#606062"
        }
    }
}
