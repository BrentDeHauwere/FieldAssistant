#pragma once
#include <QObject>
#include <QString>
#include "company.h"

class User : public QObject
{
    Q_OBJECT
public:
    explicit User(QObject* parent = 0);
    explicit User(QString firstName, QString lastName, QString email, QString password, bool isKeyUser, Company* company);

    QString getFirstName();
    QString getLastName();
    QString getEmail();
    QString getPassword();
    bool getIsKeyUser();
    Company* getCompany();

    void setFirstName(QString firstName);
    void setLastName(QString lastName);
    void setEmail(QString email);
    void setPassword(QString password);
    void setIsKeyUser(bool isKeyUser);
    void setCompany(Company* company);

    ~User();

    Q_INVOKABLE bool login(QString emailAddress, QString password);
    Q_INVOKABLE bool registerKeyUser();
    Q_INVOKABLE bool sendResetMail(QString emailAddress);
    Q_INVOKABLE bool resetPassword(QString token, QString password);
    Q_INVOKABLE bool vatNumberExists(QString vatNumber);

    Q_PROPERTY(QString firstName READ getFirstName WRITE setFirstName)
    Q_PROPERTY(QString lastName READ getLastName WRITE setLastName)
    Q_PROPERTY(QString email READ getEmail WRITE setEmail)
    Q_PROPERTY(QString password READ getPassword WRITE setPassword)
    Q_PROPERTY(bool isKeyUser READ getIsKeyUser WRITE setIsKeyUser)
    Q_PROPERTY(Company* company READ getCompany WRITE setCompany)

signals:
    void msg(bool errorMsg, bool infoMsg, QString text);
    void invalidInput(QString id);

private:
    QString firstName;
    QString lastName;
    QString email;
    QString password;
    bool isKeyUser;
    Company* company;

    explicit User(const User& rhs) = delete;
    User& operator= (const User& rhs) = delete;

    QString generateToken();
};



