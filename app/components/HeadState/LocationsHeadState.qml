/*
 * Copyright (C) 2016
 *      Andrew Hayzen <ahayzen@gmail.com>
 *      Victor Thompson <victor.thompson@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.4
import Ubuntu.Components 1.3


State {
    name: "default"

    property PageHeader thisHeader: PageHeader {
        flickable: thisPage.flickable
        leadingActionBar {
            actions: [
                Action {
                    iconName: "down"
                    onTriggered: thisPage.pop()
                }
            ]
        }
        title: i18n.tr("Locations")
        trailingActionBar {
            actions: [
                Action {
                    iconName: "add"
                    objectName: "addLocation"
                    onTriggered: mainPageStack.push(Qt.resolvedUrl("../../ui/AddLocationPage.qml"))
                }
            ]
        }
        visible: thisPage.state === "default"
    }
    property Item thisPage

    PropertyChanges {
        target: thisPage
        header: thisHeader
    }
}
