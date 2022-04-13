import QtQuick.LocalStorage 2.0
import QtQuick.Controls 2.5
import QtQuick.Window 2.3
import QtQuick 2.15
import QtQml 2.3
import "Database.js" as Db
import "Time.js" as Time

Rectangle {
    id: systemMenuButton
    color: "red"
    radius: 6
    height: 12
    width: 12
    function _tapped(){

    }
    TapHandler {
        onTapped: _tapped()
    }
}
