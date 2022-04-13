/*
 *    toniess 2022
 *
 *
 *  Item that will be a list element like note
 *  consisits of checkbox, text and also time left for deadline
 *
 *
*/
import QtQuick.LocalStorage 2.0
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import QtQuick 2.15
import QtQml 2.15
import "qrc:/Database.js" as Db
import "qrc:/Time.js" as Time

Item {
    id: taskItem
    property int noteId
    property string noteText: "stndrt"
    property bool noteStatus: false
    property bool editMode: false
    property string noteDone: "stndrt"

    onNoteStatusChanged: {
        updateData()
    }
    onEditModeChanged: editId = editMode? noteId : -1
    width: today.width
    height: 40
    x: 20
    function updateData() {
        Db.update(noteId, noteText, noteStatus, noteDone)
        progressToday = Db.getTodayProgress(Time.getCurrentDateTime())
    }

    Connections{
        target: today
        function onEndEditMode(){
            if(editId == noteId)
            {
                editId = -1
                editMode = false
                updateData()
            }
        }
    }


    Rectangle {width: parent.width; height: 20; color: "transparent"; anchors.top: row.bottom
        Rectangle{width: parent.width; height: 1; opacity: 0.1; anchors.horizontalCenter: parent.horizontalCenter}
    }
    Row{
        id: row
        anchors.fill: parent
        spacing: 10
        HoverHandler {
            id: hh
            cursorShape: Qt.PointingHandCursor
        }

        Rectangle {
            anchors.verticalCenter: row.verticalCenter
            width: 20
            height: width
            radius: width/2
            color: noteStatus? "steelblue" : "transparent"
            border{color: "grey"; width: !noteStatus}
            Image {
                visible: noteStatus
                height: 22
                width:  22
                anchors.centerIn: parent
                source: "/img/okey.png"
            }
        }
        TextInput{
            id: text
            opacity: 1 - 0.75 * noteStatus
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 2
            text: noteText
            color: "white"
            readOnly: !editMode
            font.family: noteFont.name
            selectionColor: "steelblue"
            font.pixelSize: 16
            onTextChanged: {
                noteText = text.text;
                if(text.width > today.listWidth)
                    today.listWidth = text.width
            }
            maximumLength: 50
            Component.onCompleted: {
                if(text.width > today.listWidth)
                    today.listWidth = text.width
            }
        }
        Rectangle {
            id: toolBut
            anchors.verticalCenter: row.verticalCenter
            width: 20
            height: 20
            radius: width/3
            color: lhh.hovered? "#75746f" : "transparent"
            opacity: 0.5
            HoverHandler {id: lhh}
            TapHandler {onTapped: contextMenu.popup()}
            Image {
                id: menuImg
                visible: mouse.containsMouse || hh.hovered || contextMenu.visible
                width: 14
                height: 14
                anchors.centerIn: parent
                source: "qrc:/img/contextMenu.png"
            }
        }
    }
    MouseArea {
        id: mouse
        hoverEnabled: true
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: editMode? 25 : 25 + text.width
        onClicked: {
            noteStatus = !noteStatus
            editMode = false
            if(mode != "today"){
                flyAwayAnim.start()
            }
        }
        NumberAnimation {
            id: flyAwayAnim
            target: taskItem
            property: "x"
            to: -taskItem.width
            duration: 300
            onFinished: updateTaskList()
        }

        cursorShape: Qt.PointingHandCursor
    }

    Menu {
        id: contextMenu

        Action {
            id: ac1
            enabled: mode != "done"
            text: qsTr("Переименовать");
            icon{
                source: "qrc:/img/rename.svg"
                color: ac1.enabled? "white":"grey"
                width: 24
                height: 24
            }
            function tog() {
                editMode = true
                text.cursorVisible = true
                text.forceActiveFocus()
                text.selectAll()
            }

            onTriggered: {
                if(!noteStatus) {
                    tog()
                }
            }
        }
        Action {
            id: ac2
            text: qsTr("Удалить");
            icon{
                source: "qrc:/img/delete-red.svg"
                width: 24
                height: 24
            }
            onTriggered: {
                deleteTask(noteId)
            }
        }
        delegate: MenuItem {
                 id: menuItem
                 implicitWidth: 150
                 implicitHeight: 30


                indicator: Image {
                    anchors.verticalCenter: parent.verticalCenter
                    x: 3
                        width: 20
                        height: 20
                        source: parent.text == "Удалить"? "qrc:/img/delete-red.svg" : "qrc:/img/rename.svg"
                        opacity: enabled? 1 : 0.4
                }
        contentItem: Text {
                     leftPadding: menuItem.indicator.width
                     rightPadding: menuItem.arrow.width
                     text: menuItem.text
                     font: menuItem.font
                     opacity: enabled ? 1.0 : 0.3
                     color: "white"
                     horizontalAlignment: Text.AlignLeft
                     verticalAlignment: Text.AlignVCenter
                     elide: Text.ElideRight
                 }

                 background: Rectangle {
                     implicitWidth: 150
                     implicitHeight: 30
                     opacity: enabled ? 1 : 0.6
                     radius: implicitHeight/3
                     color: menuItem.highlighted ? "#5d5c5f" : "transparent"
                 }
             }
        background: Rectangle{
            color: "#222329"
            implicitHeight: 30
            implicitWidth: 150
            radius: implicitHeight/3
            clip: true
            border{
                color: "#5d5c5f"
                width: 1
            }
        }
    }
}
