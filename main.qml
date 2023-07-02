import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15


ApplicationWindow {
	id: root

	property bool startDrone: false
	property bool sendThott: false
	property bool sendRoll: false
	property bool sendPitch: false
	property bool sendYaw: false

	visible: true
	width: 640
	height: 480
	title: qsTr("Drone Control")

	Timer {
		id: sendTimer
	}

	function startSendTimer(period, callback) {
		if (sendTimer.running) {
			return;
		}

		sendTimer.interval = period;
		sendTimer.repeat = true;
		sendTimer.triggered.connect(callback);
		sendTimer.start();
	}

	Component.onCompleted: {
		startSendTimer(100, function() {
			var temp = "";
			if (sendThott) {
				sendThott = false;
				temp = "T" + " " + thrott.value.toString() + "\n";
				TxBluetooth.sendData(temp.toString());
				return;
			} else if (sendRoll) {
				sendRoll = false;
				temp = "R" + " " + roll.value.toString() + "\n";
				TxBluetooth.sendData(temp.toString());
				return;
			} else if (sendPitch) {
				sendPitch = false;
				temp = "P" + " " + pitch.value.toString() + "\n";
				TxBluetooth.sendData(temp.toString());
				return;
			} else if (sendYaw) {
				sendYaw = false;
				temp = "Y" + " " + yaw.value.toString() + "\n";
				TxBluetooth.sendData(temp.toString());
				return;
			}
		});
	}

	ColumnLayout {
		id: column
		spacing: 20

		RowLayout {
			spacing: 5

			Text {
				id: deviceText

				anchors {
					top: root.top
					left: root.left
					right: left.right
				}
				height: 50

				text: ""
			}

			Text {
				id: statusText

				anchors {
					top: root.top
					left: root.left
					right: left.right
				}
				height: 50

				text: startDrone.toString()
			}
		}

		ColumnLayout {
			spacing: 10

			Text {
				text: qsTr("Throttle Control")
			}

			RowLayout {
				spacing: 5

				Slider {
					id: thrott

					from: 1000
					to: 2000
					stepSize: 1

					implicitWidth: root.width - 80

					onValueChanged: {
						sendThott = true;
					}
				}

				Text {
					text: thrott.value
				}
			}
		}

		ColumnLayout {
			spacing: 10

			Text {
				text: qsTr("Roll Control")
			}

			RowLayout {
				spacing: 5

				Slider {
					id: roll

					from: 1400
					to: 1600
					value: 1500
					stepSize: 1

					implicitWidth: root.width - 80

					onPressedChanged: {
						if (!pressed) {
							value = 1500;
							sendRoll = true;
						}
					}

					onValueChanged: {
						sendRoll = true;
					}
				}

				Text {
					text: roll.value
				}

			}
		}

		ColumnLayout {
			spacing: 10

			Text {
				text: qsTr("Pitch Control")
			}

			RowLayout {
				spacing: 5

				Slider {
					id: pitch

					from: 1400
					to: 1600
					value: 1500
					stepSize: 1

					implicitWidth: root.width - 80

					onPressedChanged: {
						if (!pressed) {
							value = 1500
							sendPitch = true;
						}
					}

					onValueChanged: {
						sendPitch = true;
					}
				}

				Text {
					text: pitch.value
				}

			}
		}

		ColumnLayout {
			spacing: 10

			Text {
				text: qsTr("Yaw Control")
			}

			RowLayout {
				spacing: 5

				Slider {
					id: yaw

					from: 1000
					to: 2000
					value: 1500
					stepSize: 1

					implicitWidth: root.width - 80

					onPressedChanged: {
						if (!pressed) {
							value = 1500
							sendYaw = true;
						}
					}

					onValueChanged: {
						sendYaw = true;
					}
				}

				Text {
					text: yaw.value
				}

			}
		}

		RowLayout  {
			id: throttPrecise

			spacing: 150

			Button {

				text: "Down"

				onClicked: {
					thrott.value -= 1;
					if (thrott.value < 1000) {
						thrott.value = 1000;
					}
					var temp = thrott.value.toString();
					var send = "T " + temp + "\n";
					TxBluetooth.sendData(send);
				}
			}

			Button {

				text: "Up"

				onClicked: {
					thrott.value += 1;
					if (thrott.value > 2000) {
						thrott.value = 2000;
					}
					var temp = thrott.value.toString();
					var send = "T " + temp + "\n";
					TxBluetooth.sendData(send);
				}
			}
		}

		RowLayout  {
			id: rollPrecise

			spacing: 150

			Button {

				text: "Roll Down"

				onClicked: {
					roll.value -= 2;
					if (roll.value < 1000) {
						roll.value = 1000;
					}
					var temp = roll.value.toString();
					var send = "R " + temp + "\n";
					TxBluetooth.sendData(send);
				}
			}

			Button {

				text: "Roll Up"

				onClicked: {
					roll.value += 2;
					if (roll.value > 2000) {
						roll.value = 2000;
					}
					var temp = roll.value.toString();
					var send = "R " + temp + "\n";
					TxBluetooth.sendData(send);
				}
			}
		}

		RowLayout  {
			id: pitchPrecise

			spacing: 150

			Button {

				text: "Pitch Down"

				onClicked: {
					pitch.value -= 2;
					if (pitch.value < 1000) {
						pitch.value = 1000;
					}
					var temp = pitch.value.toString();
					var send = "P " + temp + "\n";
					TxBluetooth.sendData(send);
				}
			}

			Button {

				text: "Pitch Up"

				onClicked: {
					pitch.value += 2;
					if (pitch.value > 2000) {
						pitch.value = 2000;
					}
					var temp = pitch.value.toString();
					var send = "P " + temp + "\n";
					TxBluetooth.sendData(send);
				}
			}
		}

		RowLayout  {
			id: connectBtnLayout

			spacing: 5

			Button {

				text: "Search Drone"

				onClicked: {
					TxBluetooth.findDrone();
					deviceText.text = TxBluetooth.drone
				}
			}

			Button {

				text: "Connect Drone"

				onClicked: {
					TxBluetooth.connectToDrone();
				}
			}

			Button {

				text: "Start Drone"

				onClicked: {
					statusText.text = startDrone.toString();
					if (startDrone) {
						TxBluetooth.sendData("A 1990\n");
					} else {
						TxBluetooth.sendData("A 1000\n");
					}
					startDrone = !startDrone;
				}
			}
		}
	}
}
