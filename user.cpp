#include "user.h"
#include "src/SmtpMime"
#include <cstdlib>
#include <ctime>
#include <Enginio/Enginio>

const QByteArray backendId("BACKEND_ID");

User::User(QObject *parent) :
    QObject(parent)
{
    company = nullptr;
}

User::User(QString firstName, QString lastName, QString email, QString password, bool isKeyUser, Company* company) :
    firstName(firstName),
    lastName(lastName),
    email(email),
    password(password),
    isKeyUser(isKeyUser)
{
    setCompany(company);
}

QString User::getFirstName() {
    return firstName;
}

QString User::getLastName() {
    return lastName;
}

QString User::getEmail() {
    return email;
}

QString User::getPassword() {
    return password;
}

bool User::getIsKeyUser() {
    return isKeyUser;
}

Company* User::getCompany() {
    return company;
}

void User::setFirstName(QString firstName) {
    this->firstName = firstName;
}

void User::setLastName(QString lastName) {
    this->lastName = lastName;
}

void User::setEmail(QString email) {
    this->email = email;
}

void User::setPassword(QString password) {
    this->password = password;
}

void User::setIsKeyUser(bool isKeyUser) {
    this->isKeyUser = isKeyUser;
}

void User::setCompany(Company* company) {
    if (this->company == nullptr) // No company initialised yet
    {
        if (company != nullptr)
            this->company = new Company(company->getVatNumber(), company->getCompanyName());
        else
            this->company = new Company("nullptr", "nullptr");
    }
    else // Company already initialised
    {
        if (company != nullptr)
        {
            this->company->setVatNumber(company->getVatNumber());
            this->company->setCompanyName(company->getCompanyName());
        }
        else
        {
            this->company->setVatNumber("nullptr");
            this->company->setCompanyName("nullptr");
        }
    }
}

User::~User() {
    if (company != nullptr)
        delete company;
}

bool User::login(QString emailAddress, QString password)
{
    QString companyId;

    EnginioClient* client = new EnginioClient;
    client->setBackendId(backendId);

    // Get user
    QJsonObject user;
    user.insert("objectType", QString("objects.user"));
    user.insert("email", emailAddress);
    user.insert("password", password);
    EnginioReply* replyUser = client->query(user);
    connect(replyUser, &EnginioReply::finished, [&companyId, this] (EnginioReply* replyUser) {
        if (replyUser->isError())
        {
            emit msg(true, false, tr("Oops! Something went wrong."));
            return false;
        }
        else
        {
            if (replyUser->data().empty())
            {
                emit msg(true, false, tr("Invalid email address/password."));
                emit invalidInput("emailAddressId");
                emit invalidInput("passwordId");
                return false;
            }
            else
            {
                this->firstName = replyUser->data()["firstName"].toString();
                this->lastName = replyUser->data()["lastName"].toString();
                this->email = replyUser->data()["email"].toString();
                this->password = replyUser->data()["password"].toString();
                this->isKeyUser = replyUser->data()["isKeyUser"].toBool();
                companyId = replyUser->data()["companyId"].toString();
            }
        }
        replyUser->deleteLater();
    });

    // Get company
    QJsonObject company;
    company.insert("objectType", QString("objects.company"));
    company.insert("id", companyId);
    EnginioReply* replyCompany = client->query(company);
    connect(replyCompany, &EnginioReply::finished, [this] (EnginioReply* replyCompany) {
        if (replyCompany->isError())
        {
            msg(true, false, tr("Oops! Something went wrong."));
            return false;
        }
        else
        {
            Company* tempCompany = new Company(replyCompany->data()["vatNumber"].toString(), replyCompany->data()["companyName"].toString());
            this->company = tempCompany;
            delete tempCompany;
        }
        replyCompany->deleteLater();
    });

    delete client;
    return true;
}

bool User::registerKeyUser()
{
//    EnginioClient* client = new EnginioClient;
//    client->setBackendId(backendId);

//    // Email not used yet?
//    QJsonObject checkMail;
//    checkMail.insert("objectType", QString("objects.user"));
//    checkMail.insert("email", email);
//    EnginioReply* replyCheckMail = client->query(checkMail);
//    connect(replyCheckMail, &EnginioReply::finished, [this] (EnginioReply* replyCheckMail) {
//        if (replyCheckMail->isError())
//        {
//            emit this->msg(true, false, tr("Oops! Something went wrong."));
//            return false;
//        }
//        else
//        {
//            if (!replyCheckMail->data().empty())
//            {
//                msg(true, false, tr("This email address is already registrated."));
//                return false;
//            }

//        }
//        replyCheckMail->deleteLater();
//    });

//    // Save company to database
//    QJsonObject company;
//    company.insert("objectType", QString("objects.company"));
//    company.insert("vatNumber", this->company->getVatNumber());
//    company.insert("companyName", this->company->getCompanyName());
//    EnginioReply* replyCompany = client->create(company); // Send request
//    connect(replyCompany, &EnginioReply::finished, [] (EnginioReply* replyCompany) {
//        if (replyCompany->isError())
//        {
//            msg(true, false, tr("Oops! Something went wrong."));
//            return false;
//        }
//        replyCompany->deleteLater();
//    });

//    // Get companyId
//    QString companyId;
//    QJsonObject getCompanyId;
//    company.insert("objectType", QString("objects.company"));
//    company.insert("vatNumber", this->company->getVatNumber());
//    EnginioReply* replyCompanyId = client->query(getCompanyId);
//    connect(replyCompanyId, &EnginioReply::finished, [&companyId] (EnginioReply* replyCompanyId) {
//        if (replyCompanyId->isError())
//        {
//            emit msg(true, false, tr("Oops! Something went wrong."));
//            return false;
//        }
//        else
//        {
//            companyId = replyCompanyId->data()["id"].toString();
//        }
//        replyCompanyId->deleteLater();
//    });

//    // Save key-user to database
//    QJsonObject user;
//    user.insert("objectType", QString("objects.user"));
//    user.insert("firstName", firstName);
//    user.insert("lastName", lastName);
//    user.insert("email", email);
//    user.insert("password", password);
//    user.insert("isKeyUser", isKeyUser);
//    user.insert("companyId", companyId);
//    EnginioReply* replyUser = client->create(user);
//    connect(replyUser, &EnginioReply::finished, [] (EnginioReply* replyUser) {
//        if (replyUser->isError())
//        {
//            msg(true, false, tr("Oops! Something went wrong."));
//            return false;
//        }
//        replyUser->deleteLater();
//    });

//    delete client;
//    return true;
}

bool User::sendResetMail(QString emailAddress)
{    
//    EnginioClient* client = new EnginioClient;
//    client->setBackendId(backendId);

//    QString token;
//    bool tokenExists;

//    do {
//        // Generate random token
//        token = generateToken();

//        // Check if token already exists: regenerate token
//        QJsonObject checkToken;
//        tokenExists = false;
//        checkToken.insert("objectType", QString("objects.userReset"));
//        checkToken.insert("token", token);
//        EnginioReply* checkTokenReply = client->query(checkToken);
//        connect(checkTokenReply, &EnginioReply::finished, [&tokenExists] (EnginioReply* checkTokenReply) {
//            if (checkTokenReply->isError())
//            {
//                msg(true, false, tr("Oops! Something went wrong."));
//                return false;
//            }
//            else
//            {
//                if (!checkTokenReply->data().empty())
//                    tokenExists = true;
//            }
//            checkTokenReply->deleteLater();
//        });
//    } while(tokenExists);

//    // Get userId, firstName and lastName based on email address
//    QJsonObject getUserId;
//    QString userId, firstName, lastName;
//    getUserId.insert("objectType", QString("objects.user"));
//    getUserId.insert("email", emailAddress);
//    EnginioReply* userIdReply = client->query(getUserId);
//    connect(userIdReply, &EnginioReply::finished, [] (EnginioReply* userIdReply) {
//        if (userIdReply->isError())
//        {
//            msg(true, false, tr("Oops! Something went wrong."));
//            return false;
//        }
//        else
//        {
//            if (userIdReply->data().empty())
//            {
//                msg(true, false, tr("Email address not registrated."));
//                invalidInput("emailAddressId");
//                return false;
//            }
//            else
//            {
//                userId = userIdReply->data()["id"];
//                firstName = userIdReply->data()["firstName"];
//                lastName = userIdReply->data()["lastName"];
//            }
//        }
//        userIdReply->deleteLater();
//    });

//    // Check if userId already has a token: replace with new token
//    // Else: add token to database
//    QString tokenId = "";
//    QJsonObject checkHasToken;
//    checkHasToken.insert("objectType", QString("objects.userReset"));
//    checkHasToken.insert("userId", userId);
//    EnginioReply* hasTokenReply = client->query(checkHasToken);
//    connect(hasTokenReply, &EnginioReply::finished, [] (EnginioReply* hasTokenReply) {
//        if (hasTokenReply->isError())
//        {
//            msg(true, false, tr("Oops! Something went wrong."));
//            return false;
//        }
//        else
//        {
//            if (!hasTokenReply->data().empty())
//            {
//                tokenId = hasTokenReply->data()["id"];
//            }
//        }
//        hasTokenReply->deleteLater();
//    });

//    if (tokenId != "") // Update entry
//    {
//        QJsonObject updateToken;
//        updateToken.insert("id", tokenId);
//        updateToken.insert("objectType", QString("objects.userReset"));
//        updateToken.insert("token", token);
//        EnginioReply* updateTokenReply = client->update(updateToken);
//        connect(updateTokenReply, &EnginioReply::finished, [] (EnginioReply* updateTokenReply) {
//            if (updateTokenReply->isError())
//            {
//                msg(true, false, tr("Oops! Something went wrong."));
//                return false;
//            }
//            updateTokenReply->deleteLater();
//        });
//    }
//    else // New entry
//    {
//        QJsonObject createToken;
//        createToken.insert("objectType", QString("objects.userReset"));
//        createToken.insert("userId", userId);
//        createToken.insert("token", token);
//        EnginioReply* createTokenReply = client->create(createToken);
//        connect(createTokenReply, &EnginioReply::finished, [] (EnginioReply* createTokenReply) {
//            if (createTokenReply->isError())
//            {
//                msg(true, false, tr("Oops! Something went wrong."));
//                return false;
//            }
//            createTokenReply->deleteLater();
//        });
//    }

//    delete client;

//    // Send mail with token
//    SmtpClient smtp("smtp.mail.yahoo.com", 465, SmtpClient::SslConnection);
//    smtp.setUser("fieldassistant@yahoo.be");
//    smtp.setPassword("SummerChallenge2015");

//    MimeMessage message;
//    message.setSender(new EmailAddress("fieldassistant@yahoo.be","Field Assistant"));
//    message.addRecipient(new EmailAddress(emailAddress, firstName + " " + lastName));
//    message.setSubject(tr("Field Assistant - Reset password token"));
//    message.addPart(new MimeText(tr(QString("Hi,\nToken: %1\nThis token is valid for 24 hours.\nKind regards,\nThe Field Assistant team")).arg(token)));

//    if (!smtp.connectToHost()) {
//        qDebug() << "Failed to connect to host!" << endl;
//        msg(true, false, tr("Failed to send reset mail."));
//        return false;
//    }

//    if (!smtp.login()) {
//        qDebug() << "Failed to login!" << endl;
//        msg(true, false, tr("Failed to send reset mail."));
//        return false;
//    }

//    if (!smtp.sendMail(message)) {
//        qDebug() << "Failed to send mail!" << endl;
//        msg(true, false, tr("Failed to send reset mail."));
//        return false;
//    }

//    qDebug() << "Mail sent!" << endl;
//    msg(false, true, tr("Reset mail sent. It might take a few minutes to receive."));

//    smtp.quit();
}

bool User::resetPassword(QString token, QString password)
{
    // TO DO: reset password
    // Token valid for 24 hours
}

bool User::vatNumberExists(QString vatNumber)
{
//    EnginioClient* client = new EnginioClient;
//    client->setBackendId(backendId);

//    QJsonObject queryCompany;
//    queryCompany["objectType"] = QString::fromUtf8("objects.company");
//    queryCompany["vatNumber"] = vatNumber;
//    EnginioReply* companyReply = client->query(queryCompany);
//    connect(companyReply, &EnginioReply::finished, [] (EnginioReply* companyReply) {
//        if (companyReply->isError())
//        {
//            msg(true, false, tr("Oops! Something went wrong."));
//            return false;
//        }
//        else
//        {
//            if (!companyReply->data().isEmpty())
//            {
//                msg(true, false, tr("This VAT number is already registrated."));
//                return false;
//            }

//        }
//        companyReply->deleteLater();
//    });

//    delete client;

//    return true;
}

QString User::generateToken()
{
    QString alphanum = "0123456789!@#$%^&*ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
    QString token;

    srand(time(0));

    for (int i = 0; i < 20; i++)
    {
        token.append(alphanum[rand() % 70]);
    }

    return token;
}
