#include "company.h"

Company::Company(QObject *parent) :
    QObject(parent)
{
}

Company::Company(QString vatNumber, QString companyName) :
    vatNumber(vatNumber),
    companyName(companyName)
{
}

QString Company::getVatNumber() {
    return vatNumber;
}

QString Company::getCompanyName() {
    return companyName;
}

void Company::setVatNumber(QString vatNumber) {
    this->vatNumber = vatNumber;
}

void Company::setCompanyName(QString companyName) {
    this->companyName = companyName;
}
