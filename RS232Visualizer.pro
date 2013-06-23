QT += widgets qml quick serialport
CONFIG += console
TARGET = application

SOURCES += \
    main.cpp \
    rs232visualizermain.cpp \
    serialconnect.cpp

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
    serialconnect.h

ICON += bitmaps/logo.png
