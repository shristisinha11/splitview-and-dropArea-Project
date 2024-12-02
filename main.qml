import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    visible: true
    width: 800
    height: 600
    title: "Split and Resize Screens"

    property bool isSplit: false // Tracks whether the screen is split
    property int initialSmallScreenWidth: 200 // Width of the small screen before split
    property int initialSmallScreenHeight: 200 // Height of the small screen before split

    Rectangle {
        id: container
        anchors.fill: parent
        color: "lightgray"

        // Background screen
        Rectangle {
            id: backgroundScreen
            anchors.fill: parent
            color: "skyblue"
            visible: !isSplit // Visible only when not split

            Text {
                anchors.centerIn: parent
                text: "Background Screen"
                color: "white"
            }
        }

        // Small Screen (Before Split)
        Rectangle {
            id: smallScreen
            visible: !isSplit
            width: initialSmallScreenWidth
            height: initialSmallScreenHeight
            x: container.width - width - 20
            y: container.height - height - 20
            color: "lightgreen"
            z: 1 // to bring foreground

            Text {
                anchors.centerIn: parent
                text: "Small Screen"
                color: "black"
            }

            MouseArea {
                anchors.fill: parent
                drag.target: smallScreen
                onReleased: {
                    if (smallScreen.x < container.width / 2 && !isSplit) {
                        console.log("Splitting the screens...");
                        splitScreen(); // Trigger split view
                    }
                }
            }
        }

        // Left Panel
        Rectangle {
            id: leftPanel
            visible: isSplit
            width: initialSmallScreenWidth
            height: container.height
            x: 0
            color: "lightgreen"

            Text {
                anchors.centerIn: parent
                text: "small screen"
                color: "black"
            }
        }

        // Right Panel
        Rectangle {
            id: rightPanel
            visible: isSplit
            width: container.width - leftPanel.width
            height: container.height
            x: leftPanel.width
            color: "lightblue"

            Text {
                anchors.centerIn: parent
                text: "background screen"
                color: "black"
            }
        }

        // Resizer Handle
        Rectangle {
            id: resizer
            visible: isSplit
            width: 10
            height: container.height
            color: "darkgray"
            x: leftPanel.width
            z: 2

            MouseArea {
                anchors.fill: parent
                drag.target: resizer
                drag.axis: Drag.XAxis
                cursorShape: Qt.SizeHorCursor

                onReleased: {
                    leftPanel.width = resizer.x;
                    rightPanel.width = container.width - resizer.x;
                    rightPanel.x = resizer.x;
                }
            }
        }
    }

    // Function to handle the split screen logic
    function splitScreen() {
        isSplit = true;
        // Transition smallScreen to leftPanel
        leftPanel.width = smallScreen.width;
        leftPanel.height = container.height;
        smallScreen.visible = false;
        rightPanel.width = container.width - leftPanel.width;
        rightPanel.height = container.height;
        rightPanel.x = leftPanel.width;
    }
}
