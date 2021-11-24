#ifndef MOVEHANDLER_H
#define MOVEHANDLER_H

#include <QtCore>
#include <QObject>
#include <QAccelerometer>

class MoveHandler : public QObject
{
    Q_OBJECT
private:

    QAccelerometer m_accelerometer;
    QTimer m_timer;
    int m_workTime;
    int m_moveTime;
    int m_currentX;
    int m_currentY;
    int m_oldX;
    int m_oldY;

    void init();

private slots:
    void slotTimeout();
public:
    explicit MoveHandler(QObject *parent = nullptr);
public slots:
    void slotStart();
    void slotStop();
    void slotReadingChanged();

signals:
    void signalStop(int workTime, int moveTime);
    void signalReadingChanged(int x, int y);

};

#endif // MOVEHANDLER_H
