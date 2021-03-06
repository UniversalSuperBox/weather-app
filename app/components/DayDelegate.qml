/*
 * Copyright (C) 2015 Canonical Ltd
 *
 * This file is part of Ubuntu Weather App
 *
 * Ubuntu Weather App is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * Ubuntu Weather App is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.4
import Ubuntu.Components 1.3

ListItem {
    id: dayDelegate
    objectName:"dayDelegate" + index
    height: collapsedHeight

    property int collapsedHeight: units.gu(8)
    property int expandedHeight: collapsedHeight + units.gu(4) + (expandedInfo.item ? expandedInfo.item.height : 0)

    property alias day: dayLabel.text
    property alias image: weatherImage.name
    property alias high: highLabel.text
    property alias low: lowLabel.text

    property alias modelData: expandedInfo.modelData

    state: "normal"
    states: [
        State {
            name: "normal"
            PropertyChanges {
                target: dayDelegate
                height: collapsedHeight
            }
            PropertyChanges {
                target: expandedInfo
                opacity: 0
            }
        },
        State {
            name: "expanded"
            PropertyChanges {
                target: dayDelegate
                height: expandedHeight
            }
            PropertyChanges {
                target: expandedInfo
                opacity: 1
            }
        }
    ]

    transitions: [
        Transition {
            from: "normal"
            to: "expanded"
            SequentialAnimation {
                ScriptAction {
                    script: expandedInfo.active = true
                }
                NumberAnimation {
                    easing.type: Easing.InOutQuad
                    properties: "opacity"
                }
                ScriptAction {  // run animation to ensure the listitem fits
                    script: waitEnsureVisible.restart()
                }
            }
        },
        Transition {
            from: "expanded"
            to: "normal"
            SequentialAnimation {
                NumberAnimation {
                    easing.type: Easing.InOutQuad
                    properties: "opacity"
                }
                ScriptAction {
                    script: expandedInfo.active = false
                }
            }
        }
    ]

    onClicked: {
        state = state === "normal" ? "expanded" : "normal"
        locationPages.collapseOtherDelegates(index)
    }

    Item {
        id: mainInfo

        height: collapsedHeight
        anchors {
            left: parent.left
            right: parent.right
            margins: units.gu(2)
        }

        Label {
            id: dayLabel
            anchors {
                left: parent.left
                right: weatherImage.left
                rightMargin: units.gu(1)
                top: parent.top
                topMargin: (collapsedHeight - dayLabel.height) / 2
            }
            elide: Text.ElideRight
            font.weight: Font.Light
            fontSize: "medium"
        }

        Icon {
            id: weatherImage
            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: dayLabel.verticalCenter
            }
            height: units.gu(3)
            width: units.gu(3)
        }

        Label {
            id: lowLabel
            anchors {
                left: weatherImage.right
                right: highLabel.left
                rightMargin: units.gu(1)
                verticalCenter: dayLabel.verticalCenter
            }
            elide: Text.ElideRight
            font.pixelSize: units.gu(2)
            font.weight: Font.Light
            fontSize: "medium"
            height: units.gu(2)
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignTop  // AlignTop appears to align bottom?
        }

        Label {
            id: highLabel
            anchors {
                bottom: lowLabel.bottom
                right: parent.right
            }
            color: UbuntuColors.orange
            elide: Text.ElideRight
            font.pixelSize: units.gu(3)
            font.weight: Font.Normal
            height: units.gu(3)
            verticalAlignment: Text.AlignTop  // AlignTop appears to align bottom?
        }
    }

    Loader {
        id: expandedInfo
        active: false
        anchors {
            bottomMargin: units.gu(2)
            horizontalCenter: parent.horizontalCenter
            top: mainInfo.bottom
        }
        asynchronous: true
        opacity: 0
        source: "DayDelegateExtraInfo.qml"

        property var modelData
    }

    Behavior on height {
        NumberAnimation {
            id: heightAnimation
            easing.type: Easing.InOutQuad
        }
    }

    NumberAnimation {
        // animation to ensure the listitem fits by moving the contentY
        id: ensureVisibleAnimation
        easing.type: Easing.InOutQuad
        properties: "contentY"
        target: dayDelegate.parent.parent
    }

    Timer {
        id: waitEnsureVisible
        interval: 16
        repeat: false

        onTriggered: {
            // Only trigger once the loader has loaded
            // and the animations have stopped
            // otherwise restart the timer
            if (expandedInfo.active && expandedInfo.status === Loader.Ready
                    && !heightAnimation.running) {
                // stop the current animation
                ensureVisibleAnimation.running = false;

                // Get the current position
                var view = dayDelegate.parent.parent;
                var pos = view.contentY;

                // Tell the listview to make the listitem fit
                view.positionViewAtIndex(index, ListView.Contain);

                // Animate from the original position to the new position
                ensureVisibleAnimation.from = pos;
                ensureVisibleAnimation.to = view.contentY;
                ensureVisibleAnimation.running = true;
            } else {
                restart()
            }
        }
    }

    Component.onCompleted: {
        locationPages.collapseOtherDelegates.connect(function(otherIndex) {
            if (dayDelegate && typeof index !== "undefined" && otherIndex !== index) {
                state = "normal"
            }
        });
    }
}
