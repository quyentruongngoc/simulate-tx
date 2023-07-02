#ifndef TXBLUETOOTH_H
#define TXBLUETOOTH_H

#include <QObject>
#include <qbluetoothserver.h>
#include <qbluetoothserviceinfo.h>
#include <qbluetoothlocaldevice.h>
#include <qbluetoothservicediscoveryagent.h>
#include <QString>
#include <QVector>

//static const QString serviceUuid(QStringLiteral("e8e10f95-1a70-4b27-9ccf-02010264e9c9"));

class TxBluetooth : public QObject {
	Q_OBJECT
	Q_PROPERTY(QString drone READ drone WRITE setDrone NOTIFY droneChanged)

public:
	TxBluetooth();
	~TxBluetooth();

	QString drone() {return m_drone;}

public slots:
	void deviceDiscovered(const QBluetoothDeviceInfo &device);
	void findDrone();
	void setDrone(const QString &drone);
	void connectToDrone();
	void sendData(const QString &data);

signals:
	void droneChanged();

private:
	QBluetoothSocket *m_blthSocket = nullptr;
	QBluetoothDeviceDiscoveryAgent *m_blthAgent = nullptr;
	QVector<QBluetoothDeviceInfo> m_deviceList;
	QBluetoothDeviceInfo m_droneDevice;
	QString m_drone = "";

};

#endif // TXBLUETOOTH_H
