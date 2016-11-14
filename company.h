#pragma once
#include <QObject>
#include <QString>

class Company : public QObject
{
    Q_OBJECT
public:
    explicit Company(QObject* parent = 0);
    explicit Company(QString vatNumber, QString companyName);

    QString getVatNumber();
    QString getCompanyName();

    void setVatNumber(QString vatNumber);
    void setCompanyName(QString companyName);

    Q_PROPERTY(QString vatNumber READ getVatNumber WRITE setVatNumber)
    Q_PROPERTY(QString companyName READ getCompanyName WRITE setCompanyName)

private:
    QString vatNumber;
    QString companyName;

    explicit Company(const Company& rhs) = delete;
    Company& operator= (const Company& rhs) = delete;
};



