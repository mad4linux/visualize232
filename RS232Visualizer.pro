QT += widgets qml quick
CONFIG += console
TARGET = application

SOURCES += \
    main.cpp \
    rs232visualizermain.cpp \
    SerialPortThread.cpp

OTHER_FILES += \
    qml/main.qml \
    bitmaps/logo.png

RESOURCES += \
    resources.qrc

MOC_DIR = ./.moc
OBJECTS_DIR = ./.obj
UI_DIR = ./.ui
RCC_DIR = ./.rcc

HEADERS +=  rs232visualizermain.h \
            SerialPortThread.h

ICON += bitmaps/logo.png

INCLUDEPATH += /usr/local/lib/qserialport/include/QtSerialPort

LIBS += -L/usr/local/lib/qserialport/lib/ -lQtSerialPort
