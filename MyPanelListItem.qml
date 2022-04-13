import QtQuick.LocalStorage 2.0
import QtQuick.Controls 2.5
import QtQuick.Window 2.3
import QtQuick 2.15
import QtQml 2.3
import "Database.js" as Db
import "Time.js" as Time

Item{
    id: panelListItem
    property string text: ""
    property string img: ""
    property string sourcePage: ""
    property int itemHeight: icon.height + itemText.height
    property int index: 0
    height: itemText.height + icon.height
    width: parent.width
    function likeTap() {
        leftPanel.newIndex(index, row.width, y);
        workSpace.setCurrentPage(text, sourcePage)
    }
    Row{
        id: row
        TapHandler {onTapped: likeTap()}
        spacing: 3
        width: 43 + itemText.width
        Image {
            width: 24
            height: 24
            anchors.verticalCenter: parent.verticalCenter
            id: icon
            source: img
        }
        Text {
            // тест
            id: itemText
            font{
                family: mainFont.name
                pointSize: 14
            }
            anchors.verticalCenter: parent.verticalCenter
            text: panelListItem.text
            color: "white"
        }
    }
}
