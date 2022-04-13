import QtQuick.LocalStorage 2.0
import QtQuick.Controls 2.5
import QtQuick.Window 2.3
import QtQuick 2.15
import QtQml 2.3

import "qrc:/Database.js" as Db
import "qrc:/Time.js" as Time

Item{
    id: today
    anchors.fill: parent
    Component.onCompleted: forceActiveFocus()
    property string mode
    property string date
    property int listWidth: 200
    property int lastId
    property int editId: -1
    signal endEditMode()
    onModeChanged: {
        if(mode != "today"){
            listView.header = headerItem
        } else {
            listView.header = null
        }
    }

    Connections{
        target: mainWindow
        function onUpdate(mode) {
            today.mode = mode
            today.date = Time.getCurrentDateTime()
            updateTaskList()
        }
        function onSetDate(date) {
            today.date = date
            updateTaskList()
        }
    }
    ListModel {id: taskModelList}
    function updateTaskList() {
        progressToday = Db.getTodayProgress(Time.getCurrentDateTime())
        var result
        switch (mode) {
        case "today": result = Db.getToday(today.date); break
        case "done":  result = Db.getDone(); break
        case "dead":  result = Db.getDead(Time.getCurrentDateTime()); break
        }

        taskModelList.clear()
        for (let i = 0; i < result.length; ++i) {
            var item = result.item(i)
            taskModelList.append({"id":     item.id,
                                  "task":   item.task,
                                  "status": item.status,
                                  "done":   item.done})
        }
    }
    function deleteTask(id) {
        Db.erase(id)
        updateTaskList()
    }
    function addTask() {
        lastId = Db.insert("Сделать что-то", 0, today.date)
        updateTaskList()
        return lastId
    }
    Keys.onPressed: (event)=> {
        if(event.key === Qt.Key_Enter-1) {
            if(editId === -1 && mode == "today") {
                editId = addTask();
            } else  {
                endEditMode()
            }
        }
    }
    TapHandler{onTapped: today.forceActiveFocus()}
    ListView {
        id: listView
        anchors.top: parent.top
        anchors.topMargin: 30
        anchors.left: parent.left
        width: listWidth + 100
        anchors.bottom: parent.bottom
        clip: true
        model: taskModelList
        spacing: 10
        delegate: TaskItem {
            enabled: true
            noteId: id
            noteStatus: status
            noteDone: done
            noteText: task
        }

        footer: Rectangle{
            visible: mode == "today"
            enabled: mode == "today"
            color: "transparent"
            height: 50
            width: parent.width
            HoverHandler{
                cursorShape: Qt.PointingHandCursor;
                onHoveredChanged: {
                    imgPlus.source = hovered? "qrc:/img/plus-red.png" : "qrc:/img/plus.png"
                }
            }
            TapHandler {onTapped: addTask()}
            Row {
                id: row
                x: 20
                anchors.verticalCenter: parent.verticalCenter
                spacing: 10
                Image {
                    anchors.verticalCenter: parent.verticalCenter
                    id: imgPlus
                    width: 20
                    height: 20
                    source: "qrc:/img/plus.png"
                }
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: 1
                    text: "Добавить"
                    color: "white"
                    font.family: noteFont.name
                    font.pixelSize: 16
                }
            }
        }

        Component{
            id: headerItem
            Rectangle{
                color: "transparent"
                height: 50
                width: parent.width
                HoverHandler{
                    cursorShape: Qt.PointingHandCursor;
                    onHoveredChanged: {
                        imgDel.source = hovered? "qrc:/img/delete-red.svg" : "qrc:/img/delete.svg"
                    }
                }
                TapHandler {
                    onTapped: {
                        for(var i = 0; i < taskModelList.count; i++){
                            Db.erase(taskModelList.get(i).id)
                        }
                        updateTaskList()
                    }
                }
                Row {
                    x: 20
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 10
                    Image {
                        anchors.verticalCenter: parent.verticalCenter
                        id: imgDel
                        width: 20
                        height: 20
                        source: "qrc:/img/delete.svg"
                    }
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: 3
                        text: "Удалить всё"
                        color: "white"
                        font.family: noteFont.font
                        font.pixelSize: 16
                    }
                }
            }
        }
    }

}
