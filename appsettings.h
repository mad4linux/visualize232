#ifndef APPSETTINGS_H
#define APPSETTINGS_H
#include <QObject>
#include <QSettings>
#include <QCoreApplication>
#include <QMetaType>
#include <QDebug>
#include <QVariant>

class AppSettings : public QSettings
{
    Q_OBJECT

public:
    explicit AppSettings(QObject *parent = 0) : QSettings(QSettings::UserScope, QCoreApplication::instance()->organizationName(), QCoreApplication::instance()->applicationName(), parent) {}
    Q_INVOKABLE inline void setValue(const QString &key, const QVariant &value) { QSettings::setValue(key, value); }
    Q_INVOKABLE inline QVariant value(const QString &key, const QVariant &defaultValue = QVariant()) const { return QSettings::value(key, defaultValue); }

signals:
    void settingsChanged();


private:


    Q_DISABLE_COPY(AppSettings);


};

Q_DECLARE_METATYPE(AppSettings*)

#endif // APPSETTINGS_H
