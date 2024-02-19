# Task 1

Есть код backend java.
Вам необходимо его собрать в пайплайне и задеплоить с помощью Ansible роли.
Для этого бэкэнда нужна БД postgresql (можно 12 версию), её тоже разверните с помощью Ansible.
Версия java 17.

Также для приложения необходимо передать через переменные окружения учетные данные для приложения:

    QA_COURSE_01_RDS_DB_NAME=
    QA_COURSE_01_RDS_USERNAME=
    QA_COURSE_01_RDS_PASSWORD=
    QA_COURSE_01_RDS_DB_HOST=
