#include "TxBluetooth.h"

#include <QDebug>

TxBluetooth::TxBluetooth() {
	m_blthAgent = new QBluetoothDeviceDiscoveryAgent;
	connect(m_blthAgent, SIGNAL(deviceDiscovered(QBluetoothDeviceInfo)),
	        this,SLOT(deviceDiscovered(QBluetoothDeviceInfo)));
	m_blthAgent -> start();
	m_blthSocket = new QBluetoothSocket(QBluetoothServiceInfo::RfcommProtocol);
	m_deviceList.clear();
}

TxBluetooth::~TxBluetooth() {}

void TxBluetooth::deviceDiscovered(const QBluetoothDeviceInfo &device) {
	m_deviceList.append(device);
	qDebug() << "Quyen DB found: " << device.name() << " :: " << device.address().toString();
}

void TxBluetooth::findDrone() {
	for(int i = 0; i < m_deviceList.size(); ++i) {
		QString temp = m_deviceList[i].name().trimmed();
		if (temp == "HC-06") {
			qDebug() << "Found Drone";
			m_droneDevice = m_deviceList[i];
			m_drone = m_droneDevice.name() + " :: " + m_droneDevice.address().toString();
			qDebug() << "Drone: " << m_drone;
			return;
		}
	}
}

void TxBluetooth::setDrone(const QString &drone) {
	if (m_drone == drone) {
		return;
	}

	m_drone = drone;
	emit droneChanged();
}

void TxBluetooth::connectToDrone() {
	QString addr = m_droneDevice.address().toString();
	static const QString serviceUuid(QStringLiteral("00001101-0000-1000-8000-00805F9B34FB"));
	m_blthSocket->connectToService(QBluetoothAddress(addr), QBluetoothUuid(serviceUuid), QIODevice::ReadWrite);
	qDebug() << "Connecting to drone....";
}

void TxBluetooth::sendData(const QString &data) {
	qDebug() << "Data to send: " << data;
	m_blthSocket->write(data.toStdString().c_str());
}
