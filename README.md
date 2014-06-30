# Automount USB device in MOUNTDIR (/home/USERNAME/TARGEDDIR/) folder
# Автоматическое монтирование usb устройства в домашнюю папку MOUNTDIR (/home/USERNAME/TARGEDDIR/)
# version 0.1
#
# Для монтирования USB устройство должно иметь label (метку) photo (в любом регистре)
# Папка - точка монтирования создается с названием label устройства в нижнем регистре.
# Сейчас в качестве метки допускается использовать только photo. В дальнейшем возможные имена можно будет расширить.
#

Порядок действий для добавления функции автомонтирования:

1. Добавить новые правила в udev
  1.1 Скопировать файл /etc/udev/rules.d/local.rules
  1.2 Перезапустить правила udev командой: sudo udevadm control --reload-rules
2. Добавить файлы bash скриптов в /lib/udev/
  2.1 Скопировать /lib/udev/udev-automounter.sh
  2.2 Скопировать /lib/udev/udev-auto-mount.sh
  2.3 Скопировать /lib/udev/udev-unmounter.sh
  2.4 Для каждого файла 2.1, 2.2, 2.3 дать права на возможность исполнения: sudo chmod +x <имя файла bash скрипта>


Назначение файлов:

/etc/udev/rules.d/local.rules - правила для udev, по которым он будет запускать bash скрипты при добавление/удаление устройства
/lib/udev/udev-automounter.sh - вызывается при добавление устройства. запускает скрипт монтирования /lib/udev/udev-auto-mount.sh
/lib/udev/udev-auto-mount.sh  - создает точку (папку) для монтирования (если еще не существует) и выполняет монтирование
/lib/udev/udev-unmounter.sh   - отмонтирование устройства от точки монтировния

Приложение:
http://superuser.com/questions/53978/automatically-mount-external-drives-to-media-label-on-boot-without-a-user-logge
http://superuser.com/questions/31917/is-there-a-way-to-show-notification-from-bash-script-in-ubuntu
http://askubuntu.com/questions/297412/how-do-i-make-udev-rules-work
http://vishnulinux.wordpress.com/2012/03/18/device-is-already-mounted-or-mountpoint-is-busy/
http://unix.stackexchange.com/questions/44454/how-to-mount-removable-media-in-media-label-automatically-when-inserted-with
http://ubuntuforums.org/showthread.php?t=1812529