import QtQuick.Controls 2.5
import QtQuick.LocalStorage 2.15
import QtQuick.Window 2.15
import QtQuick 2.15
import QtQml 2.3

import "qrc:/Database.js" as Db
import "qrc:/Time.js" as Time

Item{
    id: done
    anchors.fill: parent
    property int lastId
    property int editId: -1
    Component.onCompleted: forceActiveFocus()
    signal endEditMode()
    signal makeFocusOn()
    Connections{
        target: mainWindow
        function onUpdate(mode) {
            if(mode === "done"){
                console.log("donePage")
                updateTaskList()
            }
        }
    }
    ListModel {id: taskModelListDone}
    function updateTaskList() {
        var result = Db.getDone()
        taskModelListDone.clear()
        for (let i = 0; i < result.length; ++i) {
            var item = result.item(i)
            taskModelListDone.append({"id":     item.id,
                                  "task":   item.task,
                                  "status": item.status,
                                  "done":   item.done})
            lastId = item.id
        }
    }
    function deleteTask(id) {
        Db.erase(id)
        updateTaskList()
    }
    Keys.onPressed: (event)=> {
        if(event.key === Qt.Key_Enter-1) {
            if(editId === -1) {
                addTask();
                makeFocusOn()
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
        width: 200
        anchors.bottom: parent.bottom
        clip: true
        model: taskModelListDone
        spacing: 10
        delegate: TaskItem {
            enabled: false
            noteId: id
            noteStatus: status
            noteDone: done
            noteText: task
        }
    }

}
