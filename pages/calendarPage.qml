
import QtQuick.Controls 2.5
import QtQml 2.3
import Qt.labs.calendar 1.0
import QtGraphicalEffects 1.15
import QtQuick 2.15
import QtQuick.Layouts 1.3
import QtQuick.Shapes 1.15

import "qrc:/Database.js" as Db
import "qrc:/Time.js" as Time

Item {
    id: calendar

    function updateHeader() {
        pageTitle = Time.getMonthName(grid.month) + " " + grid.year
    }
    Component.onCompleted: updateHeader()

    Item {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: -30
        anchors.rightMargin: 85
        Row {
            HoverHandler{
                cursorShape: Qt.PointingHandCursor
            }
            Rectangle {
                width: 40
                height: 25
                radius: 5
                color: "#5d5c5f"
                border.width: 1
                Text{
                    anchors.centerIn: parent
                    color: "white"
                    text: "<"
                }
                TapHandler{onTapped: {
                        if(grid.month == 0) {
                            grid.year--
                            grid.month = 11
                        }else grid.month--
                        updateHeader()
                    }
                }
            }
            Rectangle {
                width: 40
                height: 25
                radius: 5
                color: "#5d5c5f"
                border.width: 1
                Text{
                    anchors.centerIn: parent
                    color: "white"
                    text: ">"
                }
                TapHandler{
                    onTapped: {
                        if(grid.month == 11) {
                            grid.year++
                            grid.month = 0
                        }else grid.month++
                        updateHeader()
                    }
                }
            }
        }
    }

    GridLayout {
        anchors.fill: parent
        clip: true
        columns: 2

        DayOfWeekRow {
            locale: grid.locale
            Layout.column: 1
            Layout.fillWidth: true
            delegate: Text {
                text: model.shortName
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "white"
            }
        }

        WeekNumberColumn {
            id: weekNumberCol
            month: grid.month
            year: grid.year
            locale: grid.locale
            Layout.fillHeight: true
            delegate: Text {
                text: model.weekNumber
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "white"
            }

            Connections {
                target: grid
                function onOffWeek(weekNum){
                    console.log(weelNum)
                    if(weekNum === model.weekNumber) {
                        weekNumberCol.height = 0
                    }
                }
            }
        }

        MonthGrid {
            id: grid
            signal offWeek(var weekNum)
            month: Time.getCurrentMonth()
            year: 2022
            locale: Qt.locale("ru_RU")
            Layout.fillWidth: true
            Layout.fillHeight: true
            delegate: Item{
                id: day
                property bool isThatMonth: model.month === grid.month
                property bool isWeekEnd: Time.isWeekEnd(model.date)
                Rectangle{
                    anchors.fill: parent
                    opacity: isThatMonth? 0.8 : 0.1
                    radius: width/20
                    color: model.today? "steelblue" : isWeekEnd? "#fa919d" : "#5d5c5f"
                }
                Text {
                    text: model.day
                    anchors.centerIn: parent
                    color: "white"
                    opacity: parent.isThatMonth? 1 : 0
                }
                Rectangle {
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.margins: 2
                    color: "#e80032"
                    width: 20
                    height: 20
                    radius: 10
                    Text {
                        anchors.centerIn: parent
                        color: "white"
                        font.pointSize: 12
                        font.bold: true
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        text: Db.isTodayBusy(Time.getDate(model.date))
                    }

                    visible: Db.isTodayBusy(Time.getDate(model.date)) > 0 && isThatMonth
                }
            }
            onClicked: {
                var dayNum = date.getDate()
                var monthNum = Time.getMonthName(date.getMonth())
                monthNum = monthNum.replace(/.$/, date.getMonth() === 2 || date.getMonth() === 7? 'а' : 'я');
                setCurrentPage(dayNum + " " + monthNum, "pages/todayPage.qml")
                setDate(Time.getDate(date))
            }
        }
    }
}
