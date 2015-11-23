 МЕХАНИЗМ АВТОМАТИЧЕСКОГО МОНТИРОВАНИЯ (ОТМОНТИРОВАНИЯ) v0.2
 Требования:
 - Метки принимающиеся для монтирования:
     photo - для монтирования папки с фотографиями
     ihservice - для запуска скриптов на устройстве

 Примечания:
 - монтирование происходит в директорию: /home/vam/intrahouse
 - точка монтирования создается с именем метки при подсоединение устройства
 - если каталог с именем метки уже есть (например папка photo), то она сохраняется и просто заменяется на точку монтирования и остаётся до момента удаления устройства
 - каталог для монтирования удаляется при отсоединения устройства (кроме каталога photo)

 Порядок действий для добавления функции автомонтирования:

 1. Добавить новые правила в udev
   1.1 Скопировать файл /etc/udev/rules.d/ihusb.rules
   1.2 Перезапустить правила udev командой: sudo udevadm control --reload-rules
 2. Добавить файлы bash скриптов в /lib/udev/
   2.1 Скопировать /lib/udev/ihusb.sh
   2.4 Для файла 2.1 дать права на возможность исполнения: sudo chmod +x <имя файла bash скрипта>


 Назначение файлов:

   /etc/udev/rules.d/ihusb.rules - правила для udev, по которым он будет запускать bash скрипты при добавление/удаление устройства

   /lib/udev/ihusb.sh - вызывается при добавление и удаление устройства. создает точку (папку) для монтирования (если еще не существует) и выполняет монтирование. Выполняет запуск скриптов.                  

 АВТОЗАПУСК СКРИПТОВ
 Требования:
 - устройство должно иметь имя (метку, label) ihservice в любом регистре
 - запускаемый скрипт должен иметь имя ihservice.sh
 - запускаемый скрипт должен иметь права на исполнение (chmod +x ihservice.sh)

 Примечания:
 - путь к точке монтирования устройства в скрипте доступен из переменной ${1}

 АВТОМОНТИРОВАНИЕ ПАПКИ С ФОТО
 Требования:
 - устроство должно иметь имя (метку, label) photo в любом регистре 

 

 Приложение:
   http://superuser.com/questions/53978/automatically-mount-external-drives-to-media-label-on-boot-without-a-user-logge
   http://superuser.com/questions/31917/is-there-a-way-to-show-notification-from-bash-script-in-ubuntu
   http://askubuntu.com/questions/297412/how-do-i-make-udev-rules-work
   http://vishnulinux.wordpress.com/2012/03/18/device-is-already-mounted-or-mountcdpoint-is-busy/
   http://unix.stackexchange.com/questions/44454/how-to-mount-removable-media-in-media-label-automatically-when-inserted-with
   http://ubuntuforums.org/showthread.php?t=1812529