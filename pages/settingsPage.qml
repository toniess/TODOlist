import QtQuick 2.0

Item {
    Text {
        anchors.centerIn: parent
        color: "#5d5c5f"
        text: "404"
        font.pointSize: 350
        opacity: 0.1
    }

    Column{
        anchors.centerIn: parent
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Вот невезуха!"
            color: "white"
            font.family: mainFont.name
            font.pointSize: 30
        }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Этот раздел еще не доступен или вам нечего настраивать..."
            color: "white"
//            opacity: 0.8
            font.pointSize: 15
        }
    }
}
