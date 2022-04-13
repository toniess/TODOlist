import QtQuick.LocalStorage 2.0
import QtQuick.Controls 2.5
import QtQuick.Window 2.3
import QtQuick 2.15
import QtQml 2.3
import "Database.js" as Db
import "Time.js" as Time

Rectangle {
    id: leftBorderLine
    x: mainWindow.width * 0.2
    color: "transparent"
    onXChanged: {
        if (x <= mainWindow.width * 0.1)
            x = mainWindow.width * 0.1
        if (x >= mainWindow.width * 0.4)
            x = mainWindow.width * 0.4
    }
    HoverHandler {
        cursorShape: dragH.enabled ? Qt.SizeHorCursor : Qt.ArrowCursor
    }
    DragHandler {
        id: dragH
        //        enabled: false  //true для возможности изменять ширину левой панели
        target: leftBorderLine
    }
    Rectangle {
        height: parent.height
        width: 1
        opacity: 0.7
        color: "grey"
        anchors.centerIn: parent
    }
}
