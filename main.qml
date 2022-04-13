import QtQuick.LocalStorage 2.0
import QtQuick.Controls 2.5
import QtQuick.Window 2.3
import QtGraphicalEffects 1.15
import QtQuick 2.15
import QtQml 2.3
import "Database.js" as Db
import "Time.js" as Time

ApplicationWindow {
    id: mainWindow
    width: Screen.width / 2
    height: Screen.height / 2
    visible: true
    flags: Qt.FramelessWindowHint
    property int totalTodayDone: 0
    title: qsTr("TODO")
    signal update(var mode)
    signal setDate(var date)
    color: "transparent"
    signal setCurrentCalendarDate
    FontLoader {
        id: mainFont
        source: "fonts/Arial Bold.ttf"
    }
    FontLoader {
        id: noteFont
        source: "fonts/ayar.ttf"
    }

    Component.onCompleted: {
        Db.init()
    }
    background: Rectangle {
        id: bgRect
        radius: width / 100
        color: "#222329"
        opacity: 0.95
        clip: true
        border.width: 1
        border.color: "#5d5c5f"
    }
    Panel {
        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
        }
        width: leftBorderLine.x
    }
    WorkSpace {
        id: workSpace
    }
    MyLeftBorderLine {
        id: leftBorderLine
        anchors.verticalCenter: parent.verticalCenter
        height: parent.height
        parent: bgRect
        width: 10
    }
    Rectangle {
        id: move
        color: "transparent"
        height: 60
        width: parent.width
        DragHandler {
            id: drag
            target: move
        }
        onXChanged: {
            mainWindow.x += x
        }
        onYChanged: {
            mainWindow.y += y
        }
    }
    AppFrame {}
}
