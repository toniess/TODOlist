/*      toniess 2022
 *
 *
 *  Library consists of functions help getting date and time
 *  in strict format (YYYY-MM-DD)
 *
*/

function getCurrentDateTime() {
    var timeDate = new Date()
    return timeDate.getFullYear() + '-'
            + timeDate.getMonth() + '-'
            + timeDate.getDate()
}

function getMonthName(monthNum) {
    var months = ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август",
                  "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"]
    return months[monthNum]
}

function getCurrentMonth() {
    var timeDate = new Date()
    return timeDate.getMonth()
}

function getDate(timeDate) {
        return timeDate.getFullYear() + '-'
            + timeDate.getMonth() + '-'
            + timeDate.getDate()
}

function isWeekEnd(timeDate) {
        return timeDate.getDay() === 0 || timeDate.getDay() === 6
}

function getNumberOfWeek(date) {
    const today = date;
    const firstDayOfYear = new Date(today.getFullYear(), 0, 1);
    const pastDaysOfYear = (today - firstDayOfYear) / 86400000;
    return Math.ceil((pastDaysOfYear + firstDayOfYear.getDay() + 1) / 7);
}


