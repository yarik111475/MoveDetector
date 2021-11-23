#include "MoveHandler.h"

void MoveHandler::init()
{
    m_moveTime=0;
    m_currentX=0;
    m_currentY=0;
    m_oldX=0;
    m_oldY=0;
}

void MoveHandler::slotTimeout()
{
    if((m_oldX==m_currentX) &&
       (m_oldY==m_currentY)){
        return;
    }
    else{
        m_moveTime++;
        m_oldX=m_currentX;
        m_oldY=m_currentY;
    }
}

MoveHandler::MoveHandler(QObject *parent): QObject(parent)
{
    QObject::connect(&m_timer, SIGNAL(timeout()),
                     this, SLOT(slotTimeout()));
     m_timer.setInterval(1000);
     QObject::connect(&m_accelerometer, SIGNAL(readingChanged()),
                      this, SLOT(slotReadingChanged()));
}

void MoveHandler::slotStart()
{
    init();
    m_timer.start();
    m_elapsedTimer.start();
    m_accelerometer.start();
}

void MoveHandler::slotStop()
{
    int workTime=m_elapsedTimer.elapsed()/1000;
    m_timer.stop();
    m_accelerometer.stop();

    emit signalStop(workTime, m_moveTime);
}

void MoveHandler::slotReadingChanged()
{
    m_currentX=static_cast<int>(m_accelerometer.reading()->x());
    m_currentY=static_cast<int>(m_accelerometer.reading()->y());
    emit signalReadingChanged(m_currentX,m_currentY);
}
